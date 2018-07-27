# FIVEM secured callbacks

Sometimes you need to do like this

First script:
```lua
AddEventHandler('some:callback', function(data)
	-- do some stuff on data response
end)

TriggerEvent('some:event', 'some:callback')
```
Other script:
```lua
AddEventHandler('some:event', function(callback)
	local data = {}
	-- do something with data
	TriggerEvent(callback, data)
end)
```

But what if some hacker use this in other way, like `Trigger(Server)Event('some:event', 'system:wipeAllData')`? It will wipe your data! (in theory).
So you need filter all callbacks. You can do it with my `Secured Callbacks`

# Example (easy):

First script:
```lua
local example_callbacks = {	-- list of callbacks that need be secured way triggering
	['some:callback'] = 'some_kind_of_id'
}

local data = AddEventHandler('callback:Registered:some_kind_of_id', function(name, key, data)
	example_callbacks['some:callback'] = key -- updating key
	RemoveEventHandler(data)
end)

TriggerEvent('callback:register', 'some_kind_of_id', 'some:callback', data) -- registering callback

AddEventHandler('onResourceStart', function(resource)
	if resource == 'callbacks' then
		TriggerEvent('some:event', example_callbacks['some:callback'])
	end
end)

AddEventHandler('some:callback', function(data)
	-- do some stuff on data response
end)
```

Second script:
```lua
AddEventHandler('some:event', function(callback)
	local data = {}
	-- do something with data
	TriggerEvent('callback:secured', callback, data)	-- filtering trough callback:secured EventHandler
end)
```

# Example (pro):

First script:
```lua
local example_callbacks = {	-- list of callbacks that need be secured way triggering
	'some:callback'
}

local secure_cb = callbacks_encrypt(example_callbacks) -- create some identification keys for handle register results

for callback, key in pairs(secure_cb) do
	local data = AddEventHandler('callback:Registered:'..key, function(name, key, data)
		secure_cb[callback] = key	-- updating key
		RemoveEventHandler(data)
	end)
	TriggerEvent('callback:register', key, callback, data)	-- registering callbacks
end

AddEventHandler('onResourceStart', function(resource)
	if resource == 'callbacks' then

		-- so, now you can trigger events with secured callback, like
		for _, key in pairs(secure_cb) do
			TriggerEvent('some:event', key)
		end
		-- or in that way
		for _, key in pairs(example_callbacks) do
			TriggerEvent('some:event', secure_cb[key])
		end
		-- or in way
		TriggerEvent('some:event', secure_cb['some:callback'])

	end
end)

AddEventHandler('some:callback', function(data)
	-- do some stuff on data response
end)
```

Second script:
```lua
AddEventHandler('some:event', function(callback)
	local data = {}
	-- do something with data
	TriggerEvent('callback:secured', callback, data)	-- filtering trough callback:secured EventHandler
end)
```

This is very easy. Triggering callback event by key will protect you from baby hackers.