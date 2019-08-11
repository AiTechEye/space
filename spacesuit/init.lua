spacesuit={
	breath_timer=0,
	player_sp={},
	air=21,
	player_space={},
	itemdroptime=tonumber(minetest.settings:get("item_entity_ttl")),
}

spacesuit.itemdroptime = spacesuit.itemdroptime and spacesuit.itemdroptime - 20 or 880

dofile(minetest.get_modpath("spacesuit") .. "/nodes.lua")
dofile(minetest.get_modpath("spacesuit") .. "/craft.lua")
dofile(minetest.get_modpath("spacesuit") .. "/functions.lua")

minetest.register_tool("spacesuit:sp", {
	description = "Spacesuit (wear slot 1, works in space only)",
	inventory_image = "spacesuit_sp.png",
})

minetest.register_on_joinplayer(function(player)
	spacesuit.player_sp[player:get_player_name()]={sp=0,skin={}}
end)

minetest.register_entity("spacesuit:sp1",{
	hp_max = 100,
	physical = false,
	weight = 0,
	collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
	visual = "cube",
	visual_size = {x=0.5, y=0.5},
	textures = {"spacesuit_air.png","spacesuit_air.png","spacesuit_air.png","spacesuit_air.png","spacesuit_air.png","spacesuit_air.png"},
	spritediv = {x=1, y=1},
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = false,
	timer=0,
	on_activate=function(self, staticdata)
		if spacesuit.tmpuser then
			self.user=spacesuit.tmpuser
			spacesuit.tmpuser=nil
			self.hud=self.user:hud_add({
				hud_elem_type = "image",
				text ="spacesuit_scene.png",
				name = "spacesuit_sky",
				scale = {x=-100, y=-100},
				position = {x=0, y=0},
				alignment = {x=1, y=1},
			})
		else
			self.object:remove()
		end
	end,
	on_step= function(self, dtime)
		self.timer=self.timer+dtime
		if self.timer<2 then return end
		self.timer=0
		local p = spacesuit.player_sp[self.user:get_player_name()]
		if not (self.user:get_pos() or p) then
			self.object:remove()
			return self
		elseif self.user:get_inventory():get_stack("main", 1):get_name()~="spacesuit:sp" then
			self.object:set_detach()
			self.user:set_properties({mesh = "character.b3d",textures = p.skin})
			p.skin={}
			p.sp=0
			self.user:hud_remove(self.hud)
			self.object:remove()
			return self
		end
	end
})