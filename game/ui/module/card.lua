local C ={}

function C.create(card,pos,title,effect,cost)
	local new_card={node=card,pos=pos,title=title,effect=effect,cost=cost}
	function new_card:move_coordinate(pos)
		gui.set_position(new_card.node, pos)
	end
	function new_card:return_to_hand()
		gui.set_position(new_card.node, gui.get_screen_position(new_card.pos))
		gui.set_rotation(new_card.node, gui.get_rotation(new_card.pos))
	end
	function new_card:drop(target)
		msg.post(target, "use_card",{title=new_card.title,effect=new_card.effect,cost=new_card.cost})
	end
	function new_card:set_texture(texture)
		
	end
	return new_card
end

return C

