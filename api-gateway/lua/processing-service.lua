--
-- Rate Limiter --
--
local rate_limiter = require "rate_limiter"
rate_limiter.init()

--
-- Redis Cache --
--
local redis_cache = require "redis_cache"

-- Connect to Redis --
local redis = redis_cache.connect()
if not redis then
    return ngx.exit(500)
end

-- Lookup the key --
local key = ngx.var.arg_key
success = redis_cache.lookup_key(redis, key)

-- Close the connection --
redis_cache.close_connection(redis)

if not success then
    return ngx.exit(401)
end
