dofile(minetest.get_modpath(minetest.get_current_modname()).."/classes.lua")

-- Register Classes

classes:register_class("human", {
	mesh = "character.x",
	texture = "character.png",
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	physics = {speed=1.0, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=100},
})

classes:register_class("dwarf", {
	mesh = "dwarf_character.x",
	texture = "character_dwarf.png",
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.5,0.3},
	physics = {speed=0.8, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=80},
})

classes:register_class("elf", {
	mesh = "elf_character.x",
	texture = "character_elf.png",
	collisionbox = {-0.3,-1.0,-0.3, 0.3,1.0,0.3},
	physics = {speed=1.2, jump=1.0, gravity=1.0},
	armor_groups = {fleshy=120},
})

classes:load()

