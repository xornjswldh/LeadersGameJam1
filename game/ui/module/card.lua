local C ={}
local BATTLE_MANGAGER ="ingame:/battle_manager"
local CARD_MANGAGER ="ingame:/card_manager"
local COLOR = {
	["군인"]={vmath.vector4(0,0.3,0,1),vmath.vector4(0.2,0.5,0.2,1),vmath.vector4(0.7,1,0.7,1)},
	["과학자"]={vmath.vector4(1,1,0,1),vmath.vector4(1,1,0.5,1),vmath.vector4(1,1,0.7,1)},
	["경찰"]={vmath.vector4(0,0,1,1),vmath.vector4(0.5,0.5,1,1),vmath.vector4(0.7,0.7,1,1)},
	["도박사"]={vmath.vector4(1,0,0,1),vmath.vector4(1,0.5,0.5,1),vmath.vector4(1,0.7,0.7,1)},
	["중립"]={vmath.vector4(1,1,1,1),vmath.vector4(1,1,1,1),vmath.vector4(1,1,1,1)}
}
function C.create(node,card,pos,character,img,title,effect,cost,hold)
	local new_card={root=node,node=card,pos=pos,img=img,character=character,title=title,effect=effect,cost=cost,hold=false,wiggling=false,shaking=false}
	function new_card:initialize()
		gui.set_color(new_card.root[hash("card_sample/inner_frame")], COLOR[new_card.character][2])
		gui.set_color(new_card.root[hash("card_sample/explain_area")], COLOR[new_card.character][3])
		gui.set_color(new_card.root[hash("card_sample/title_area")], COLOR[new_card.character][3])
		gui.set_color(new_card.node, COLOR[new_card.character][1])
		gui.set_text(new_card.root[hash("card_sample/explain")],new_card.effect)
		gui.set_text(new_card.root[hash("card_sample/title")],new_card.title)
		gui.set_text(new_card.root[hash("card_sample/cost")],new_card.cost)
		gui.set_texture(new_card.root[hash("card_sample/illust")],"card_image")
		gui.play_flipbook(new_card.root[hash("card_sample/illust")], new_card.img)
	end
	function new_card:discard(pos)
		new_card:change_position(vmath.vector3(-1000,-1000,0))
		msg.post(CARD_MANGAGER, "use_card")
		timer.delay(0.1, false, function()
			gui.delete_node(new_card.node)
		end)
	end
	function new_card:change_position(pos)
		gui.set_position(new_card.node, pos)
	end
	function new_card:change_rotation(rot)
		gui.set_rotation(new_card.node, rot)
	end
	function new_card:change_scale(scale)
		gui.set_scale(new_card.node, scale)
	end
	function new_card:change_layer(layer)
		gui.set_layer(new_card.node, layer)
	end
	function new_card:wiggle(layer)
		if	new_card.wiggling == false then
			gui.animate(new_card.node, "rotation.z",  gui.get_rotation(new_card.pos).z+2, go.EASING_LINEAR, 0.3,0,nil,gui.PLAYBACK_LOOP_PINGPONG)
			new_card.wiggling =true
		end
	end
	function new_card:shake(layer)
		if	new_card.shaking == false then
			gui.set_rotation(new_card.node,vmath.vector3(0,0,3))
			gui.animate(new_card.node, "rotation.z",-3, go.EASING_LINEAR, 0.2,0,nil,gui.PLAYBACK_LOOP_PINGPONG)
			new_card.shaking =true
		end
	end
	function new_card:cancel_wiggle()
		gui.cancel_animation(new_card.node, "rotation")
		new_card:return_to_hand()
		new_card.wiggling = false
	end
	function new_card:cancel_shake()
		gui.cancel_animation(new_card.node, "rotation")
		new_card.shaking = false
	end
	function new_card:return_to_hand()
		gui.animate(new_card.node, "position",gui.get_screen_position(new_card.pos), go.EASING_LINEAR, 0.2)
		gui.animate(new_card.node, "rotation",  gui.get_rotation(new_card.pos), go.EASING_LINEAR, 0.1)
		gui.animate(new_card.node, "scale",  gui.get_scale(new_card.pos), go.EASING_LINEAR, 0.1)
	end
	function new_card:create_to_hand(pos)
		gui.set_position(new_card.node, pos)
		gui.animate(new_card.node, "position", gui.get_screen_position(new_card.pos), go.EASING_LINEAR, 0.5)
		gui.animate(new_card.node, "rotation",  gui.get_rotation(new_card.pos), go.EASING_LINEAR, 0.1)
	end
	function new_card:use()
		msg.post(BATTLE_MANGAGER, "use_card",{character=new_card.character,img=new_card.img,title=new_card.title,effect=new_card.effect,cost=new_card.cost})
		msg.post(CARD_MANGAGER, "use_card")
		new_card:change_position(vmath.vector3(-1000,-1000,0))
		timer.delay(0.1, false, function()
			gui.delete_node(new_card.node)
		end)
	end
	function new_card:set_texture(texture)
		
	end
	return new_card
end

return C

