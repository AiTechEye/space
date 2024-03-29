minetest.register_on_leaveplayer(function(player)
	spacesuit.player_sp[player:get_player_name()]=nil
end)

-- place air2 if near to it (or it will messup with corrently)
minetest.register_on_dignode(function(pos, oldnode, digger)
	if pos.y<space.y then return end
    	local np=minetest.find_node_near(pos, 1,{"space:air"})
	if np~=nil then
		minetest.set_node(pos, {name = "space:air"})
	end
end)

function spacesuit_replacenode(pos)
    	local np=minetest.find_node_near(pos, 1,{"space:air"})
	if np then
		minetest.set_node(pos, {name = "space:air"})
	else
		minetest.set_node(pos, {name = "air"})
	end
end

minetest.register_globalstep(function(dtime)
	spacesuit.breath_timer=spacesuit.breath_timer+dtime
	if spacesuit.breath_timer<2 then return end
	spacesuit.breath_timer=0
	for i, player in pairs(minetest.get_connected_players()) do
		local l=player:get_pos()
		if l.y>space.y then
			local user = spacesuit.player_sp[player:get_player_name()]
			local n = minetest.get_node({x=l.x,y=l.y+2,z=l.z}).name
			local inv = player:get_inventory()

			if user.sp==1 then
--(have spacesuit)
				if n=="space:air" and inv:get_stack("main", 1):get_name()=="spacesuit:sp" and inv:get_stack("main", 1):get_wear()>0 then
					local w=inv:get_stack("main", 1):get_wear()- (65534/20)
					if w<0 then w=0 end
					inv:set_stack("main", 1,ItemStack({name="spacesuit:sp",wear=w}))
				elseif n~="space:air" and inv:get_stack("main", 1):get_name()=="spacesuit:sp" then
					if inv:get_stack("main", 1):get_name()~="" and inv:get_stack("main", 1):get_wear()<65533 then
						player:set_breath(11)
						local w=inv:get_stack("main", 1):get_wear()+ (65534/900)
						if w>65533 then w=65533 end
						inv:set_stack("main", 1,ItemStack({name="spacesuit:sp",wear=w}))
						elseif inv:get_stack("main", 1):get_name()=="spacesuit:sp" and inv:get_stack("main", 1):get_wear()>=65533 then
						local have_more=0
						for i=0,32,1 do
							if inv:get_stack("main", i):get_name()=="spacesuit:air_gassbotte" then
								local c=inv:get_stack("main", i):get_count()-1
								inv:set_stack("main", i,ItemStack({name="spacesuit:air_gassbotte",count=c}))
								inv:set_stack("main", 1,ItemStack({name="spacesuit:sp",wear=0}))
								minetest.sound_play("spacesuit_pff", {pos=pos, gain = 1, max_hear_distance = 8,}) 
								have_more=1
								if c<4 and c>1 then minetest.chat_send_player(player:get_player_name(), "Warning: Gassbottes left: " .. c) end
								if c==0 then minetest.chat_send_player(player:get_player_name(), "Warning: Gassbottes are over!") end
								break
							end
						end
						if have_more==0 then
							user.sp=0
							minetest.chat_send_player(player:get_player_name(), "Warning: You are out of air!")
						end
					end
				end
			elseif user.sp==0 and inv:get_stack("main", 1):get_name()=="spacesuit:sp" and inv:get_stack("main", 1):get_wear()<65533 then
--(set up spacesuit)
				user.sp=1
				spacesuit.tmpuser=player
				local m=minetest.add_entity(player:get_pos(), "spacesuit:sp1")
				m:set_attach(player, "", {x=0,y=-3,z=0}, {x=0,y=0,z=0})
				user.skin=player:get_properties().textures
				player:set_properties({visual = "mesh",textures = {"spacesuit_sp2.png"},visual_size = {x=1, y=1}})
			elseif n=="air" and n~="ignore" then
--(no spacesuit and in default air: lose 8 hp)
				player:set_hp(player:get_hp()-8)
			elseif n~="space:air" and n~="ignore" then
--(no spacesuit and inside something else: lose 1 hp)
				player:set_hp(player:get_hp()-1)
			elseif user.sp==0 and n=="space:air" and inv:get_stack("main", 1):get_name()=="spacesuit:sp" and inv:get_stack("main", 1):get_wear()>=65533 then
--(set up spacesuit inair but empty)
				user.sp=1
			end
		end
	end
end)