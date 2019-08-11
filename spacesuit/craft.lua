
minetest.register_craft({
	output = "spacesuit:door1_1 2",
	recipe = {
		{"","spacesuit:shieldblock",""},
		{"","spacesuit:shieldblock", ""},
		{"","spacesuit:shieldblock", ""},
	}
})

minetest.register_craft({
	output = "spacesuit:airgen5",
	recipe = {
		{"spacesuit:shieldblock","spacesuit:air_gassbotte","spacesuit:shieldblock"},
		{"spacesuit:shieldblock","spacesuit:oxogen", "spacesuit:shieldblock"},
	}
})

minetest.register_craft({
	output = "spacesuit:air_gassbotte 2",
	recipe = {
		{"default:steel_ingot","spacesuit:oxogen","default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "spacesuit:sp",
	recipe = {
		{"spacesuit:sp","spacesuit:air_gassbotte",""}

	}
})

minetest.register_craft({
	output = "spacesuit:steelwallblock 8",
	recipe = {
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot","", "default:steel_ingot"},
		{"default:steel_ingot","default:steel_ingot","default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "spacesuit:shieldblock 4",
	recipe = {
		{"default:steel_ingot","default:steel_ingot","default:iron_lump"},
		{"default:steel_ingot","default:steel_ingot", ""},
	}
})



