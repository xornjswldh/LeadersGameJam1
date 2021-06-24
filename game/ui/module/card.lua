local C ={}
local CARD_MANAGER ="ingame:/card_manager"
local COLOR = {
	["군인"]={vmath.vector4(0,0.3,0,1),vmath.vector4(0.2,0.5,0.2,1),vmath.vector4(0.7,1,0.7,1)},
	["과학자"]={vmath.vector4(1,1,0,1),vmath.vector4(1,1,0.5,1),vmath.vector4(1,1,0.7,1)},
	["경찰"]={vmath.vector4(0,0,1,1),vmath.vector4(0.5,0.5,1,1),vmath.vector4(0.7,0.7,1,1)},
	["도박사"]={vmath.vector4(1,0,0,1),vmath.vector4(1,0.5,0.5,1),vmath.vector4(1,0.7,0.7,1)},
	["중립"]={vmath.vector4(1,1,1,1),vmath.vector4(1,1,1,1),vmath.vector4(1,1,1,1)}
}
function C.create(node,card,pos,character,title,effect,cost,hold)
	local new_card={root=node,node=card,pos=pos,character=character,title=title,effect=effect,cost=cost,hold=false}
	function new_card:initialize()
		gui.set_color(new_card.root[hash("card_sample/inner_frame")], COLOR[new_card.character][2])
		gui.set_color(new_card.root[hash("card_sample/explain_area")], COLOR[new_card.character][3])
		gui.set_color(new_card.root[hash("card_sample/title_area")], COLOR[new_card.character][3])
		gui.set_color(new_card.node, COLOR[new_card.character][1])
		gui.set_text(new_card.root[hash("card_sample/explain")],new_card.effect)
		gui.set_text(new_card.root[hash("card_sample/title")],new_card.title)
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
	function new_card:return_to_hand()
		gui.animate(new_card.node, "position", gui.get_screen_position(new_card.pos), go.EASING_LINEAR, 0.2)
		gui.animate(new_card.node, "rotation",  gui.get_rotation(new_card.pos), go.EASING_LINEAR, 0.1)
		gui.animate(new_card.node, "scale",  gui.get_scale(new_card.pos), go.EASING_LINEAR, 0.1)
	end
	function new_card:create_to_hand(pos)
		gui.set_position(new_card.node, pos)
		gui.animate(new_card.node, "position", gui.get_screen_position(new_card.pos), go.EASING_LINEAR, 0.5)
		gui.animate(new_card.node, "rotation",  gui.get_rotation(new_card.pos), go.EASING_LINEAR, 0.1)
	end
	function new_card:use()
		msg.post(CARD_MANAGER, "use_card",{character=new_card.character,title=new_card.title,effect=new_card.effect,cost=new_card.cost})
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

