-- rate_limiter.lua
local _M = {}

local limit_req = require "resty.limit.req"

function _M.init()
    -- Allow 0.5 requests per second --
    local lim, err = limit_req.new("my_limit_req_store", 0.5, 0.5)
    if not lim then
        ngx.log(ngx.ERR, "failed to instantiate a resty.limit.req object: ", err)
        return ngx.exit(500)
    end

    -- Use the visitor's IP address as a key --
    local key = ngx.var.remote_addr
    local delay, err = lim:incoming(key, true)

    -- Throw an error when the limit is reached --
    if err == "rejected" then
        ngx.log(ngx.ERR, "Limit reached: ", err)
        return ngx.exit(503)
    end
end

return _M
