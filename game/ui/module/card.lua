local C ={}

function C.create(card,pos,title,effect,cost,hold)
	local new_card={node=card,pos=pos,title=title,effect=effect,cost=cost,hold=false}
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
		--msg.post(target, "use_card",{title=new_card.title,effect=new_card.effect,cost=new_card.cost})
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

