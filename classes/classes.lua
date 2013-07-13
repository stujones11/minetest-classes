local default_class = minetest.setting_get("classes_default_class")
if not default_class then
	default_class = "human"
	minetest.setting_set("classes_default_class", default_class)
end
local has_skin_changer = minetest.get_modpath("player_textures") or minetest.get_modpath("skins")
local has_3d_armor = minetest.get_modpath("3d_armor")

classes = {
	class = {},
	properties = {},
	filename = minetest.get_worldpath().."/classes.mt",
}

classes.register_class = function(self, class, properties)
	self.properties[class] = properties
end

classes.update_player_visuals = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local class = classes.class[name]
	local properties = classes.properties[class]
	local mesh = ""
	local texture = properties.texture
--[[
	if has_3d_armor	then
		mesh = "3d_armor_"
	end
--]]
	mesh = mesh..properties.mesh
	player:set_properties({
		visual = "mesh",
		mesh = mesh,
		collisionbox = properties.collisionbox,
		visual_size = {x=1, y=1},
	})
	if not has_skin_changer then
		player:set_properties({textures={texture}})
--[[
		if has_3d_armor	then
			uniskins:update_player_visuals(player)
		end
]]--
	end 
	local physics = properties.physics
	player:set_physics_override(physics.speed, physics.jump, physics.gravity)
	player:set_armor_groups(properties.armor_groups)
end

classes.load = function(self)
	local input = io.open(self.filename, "r")
	local data = nil
	if input then
		data = input:read('*all')
	end
	if data and data ~= "" then
		lines = string.split(data, "\n")
		for _, line in ipairs(lines) do
			data = string.split(line, " ", 2)
			self.class[data[1]] = data[2]
		end
		io.close(input)
	end
end

classes.save = function(self)
	local output = io.open(self.filename,'w')
	for name, class in pairs(self.class) do
		if name and class then
			output:write(name.." "..class.."\n")
		end
	end
	io.close(output)
end

minetest.register_privilege("class", "Player can change class.")

minetest.register_chatcommand("class", {
	params = "[class]",
	description = "Change or view character class.",
	func = function(name, class)
		if class == "" then
			minetest.chat_send_player(name, "Current character class: "..classes.class[name])
			return
		end
		if not minetest.check_player_privs(name, {class=true}) then
			minetest.chat_send_player(name, "Changing class requires the 'class' privilege!")
			return
		end
		if not classes.properties[class] then
			local valid = ""
			for k,_ in pairs(classes.properties) do
				valid = valid.." "..k
			end
			minetest.chat_send_player(name, "Invalid class '"..class.."', choose from:"..valid)
			return 
		end
		if classes.class[name] == class then
			return
		end
		classes.class[name] = class
		classes:save()
		local player = minetest.get_player_by_name(name)
		classes:update_player_visuals(player)
	end,
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not classes.class[name] then
		classes.class[name] = default_class
	end
	minetest.after(1, function(player)
		classes:update_player_visuals(player)
	end, player)
end)

