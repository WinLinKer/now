---riak http client
module("now.net.riak", package.seeall)

local _cls = now.net.riak
local _mt = { __index = _cls }
local _http = require("now.net.http")
local _base = require("now.base")

---初始化，需包含的参数为 {host='',port=''}
function new(self, o)
	o = o || {
		host = "127.0.0.1",
		port = 1978
	}
	o['http'] = _http:new()
    return setmetatable(o, _mt)
end

function _read_reply(ret)
end

function _get(self, url)
	local ret = self.http:get(url)
	if ret['code'] == 200 then
		ret['body'] = _base.json_decode(ret['body'])
	end
	return ret
end
function _put(self, url)
	
end

function list_buckets(self, buckets)
	local url = '/buckets'
	if buckets ~= nil then
		url = url .. '?buckets=' .. tostring(buckets)
	end
	return self:_get(url)
end

function list_keys(self, bucket, keys)
	local url = '/buckets/'..bucket..'/keys'
	if keys ~= nil then
		url = url .. '?keys=' .. tostring(keys)
	end
	return self:_get(url)
end

function get_bucket(self, bucket, query)
	local url = '/buckets/'..bucket..'/props'
	return self:_get(url)
end

function set_bucket(self, bucket, props)
	local url = '/buckets/'..bucket..'/props'
	local ret = self.http:put(url, {["Content-Length"] = "application/json"}, _base.json_encode(props))
	return ret
end

--not support sliblings
function fetch_object(self, bucket, key)
	local url = '/buckets/'..bucket..'/keys/'..key
	return self.http:get(url)
end

function store_object(self, bucket, key, val, para)
	local url = '/buckets/'..bucket..'/keys/'..key
	if para then
		url = url .. '?' .. ngx.encode_args(para)
	end
	if type(val) == 'table' then
		return self.http:put(url, {["Content-Length"] = "application/json"}, _base.json_encode(val))
	else
		return self.http:put(url, {["Content-Length"] = "text/plain"}, val)
	end
end

function delete_object(self, bucket, key)
	local url = '/buckets/'..bucket..'/keys/'..key
	if para then
		url = url .. '?' .. ngx.encode_args(para)
	end
	return self.http:delete(url)
end

function ping(self)
	local url = '/ping'
	return self.http:get(url)
end

function status(self)
	local url = '/status'
	return self.http:get(url)
end

function list(self)
	local url = '/'
	return self.http:get(url)
end

function link_walking(self)
end

function mapred(self)
end

function index(self)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end