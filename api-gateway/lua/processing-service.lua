-- Rate Limiter

local rate_limiter = require "rate_limiter"
rate_limiter.init()

-- Auth

local jwt = require "resty.jwt"
local auth_header = ngx.var.http_Authorization
local token = nil

if auth_header then
    token = string.match(auth_header, "Bearer%s+(.+)")
end

if token == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\": \"auth header or jwt token are missing\"}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local secret = os.getenv("SECRET")
local jwt_obj = jwt:verify(secret, token)

if not jwt_obj["verified"] then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.log(ngx.WARN, jwt_obj.reason)
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\": \"" .. jwt_obj.reason .. "\"}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
