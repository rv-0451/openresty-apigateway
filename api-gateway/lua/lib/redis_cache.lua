-- redis_cache.lua
local _M = {}

local splitter = require "split"
local redis_client = require "resty.redis"

function _M.connect()
    local redis = redis_client:new()
    redis:set_timeouts(1000, 1000, 1000)

    local parts = splitter.split(os.getenv("REDIS_CONNECT_URL"), ":@")

    local res, err = redis:connect(parts[4], parts[5])
    if not res then
        ngx.log(ngx.ERR, "failed to connect: ", err)
        return nil, err
    end

    res, err = redis:auth(parts[3])
    if not res then
        ngx.log(ngx.ERR, "failed to authenticate: ", err)
        return nil, err
    end

    return redis
end

function _M.lookup_key(redis, key)
    local res, err = redis:get(key)
    if (not res) or (res == ngx.null) then
        ngx.log(ngx.ERR, "invalid key: ", err)
        return false
    end

    return true
end

function _M.close_connection(redis)
    local res, err = redis:close()
    if not res then
        ngx.log(ngx.ERR, "failed to close: ", err)
        return false
    end

    return true
end

return _M
