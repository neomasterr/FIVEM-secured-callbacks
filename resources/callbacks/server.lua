local callbacks = {}

AddEventHandler('callback:register', function(name, callback, data)
	if callback ~= nil and callback:sub(1, 9) ~= 'callback:' then
		local key = randomString(8)
		callbacks[key] = callback
		TriggerEvent('callback:Registered:'..name, name, key, data)
	else
		print('bad callback:', callback)
	end
end)

AddEventHandler('callback:secured', function(key, ...)
	if callbacks[key] ~= nil then
		TriggerEvent(callbacks[key], ...)
	end
end)

function callbacks_encrypt(data)
	local response = {}
	for _, name in ipairs(data) do
		response[name] = randomString(8)
	end
	return response
end

local charset = {} do
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function randomString(length)
	if length <= 0 then return '' end
	local rand = math.random
	local str = ''
	for i = 1, length do
		str = str .. charset[rand(1, #charset)]
	end
	return str
end