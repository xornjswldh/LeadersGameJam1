local B={}
local CARD_MANAGER="ingame:/card_manager"
local EFFECT={
	"시한 폭탄",
	"도발"
}
local CHARCTER ={
	["군인"]=1,
	["과학자"]=2,
	["경찰"]=3,
	["도박사"]=4
}
local TITLE =
{
	"신속한 타격","응급 처치","선제 공격","정밀 타격","공습 경보","방어 태세","시한 폭탄","기사 회생",
	"총기 난사","위기는 곧 기회","지원 사격","도발",
	"치유 물약","독 장판","화학 반응","재생 물약",
	"너 죽고 나 죽자","과감한 판단","심폐소생술",
	"오늘의 운세","목숨을 건 내기","재활용"
}
local function attack(self,target,damage,time,mode)
	time = time or 1
	mode = mode or "random"
	if mode == "random" then
		for i=1,time do
			local num = math.random(1,#target)
			msg.post(target[num].unit, "attack",{damage=damage})
		end
	elseif mode == "not_damaged" then
		local new_target={}
		for i=1,#target do
			if target[i].initial_hp==target[i].hp then
				table.insert(new_target, target[i])
			end
		end
		if #new_target>0 then
			for i=1,time do
				local num = math.random(1,#new_target)
				msg.post(new_target[num].unit, "attack",{damage=damage})
			end
		end
	elseif mode == "all" then
		for i=1,#self.character do
			msg.post(self.character[i].unit, "attack",{damage=damage})
		end
		for i=1,#self.enemy do
			msg.post(self.enemy[i].unit, "attack",{damage=damage})
		end
	elseif mode == "all_enemy" then
		for i=1,#self.enemy do
			msg.post(self.enemy[i].unit, "attack",{damage=damage})
		end
	elseif mode == "much_hp" then
		local hp=0
		local unit
		for i=1,#target do
			if target[i].hp>hp then
				hp=target[i].hp
				unit=target[i].unit
			end
		end
		msg.post(unit,"attack",{damage=damage})
	elseif mode=="police" then
		for i = 1, #self.character do
			if self.character[i].id == CHARCTER["경찰"] then
				msg.post(self.character[i].unit, "attack",{damage=damage})
				break
			end
		end
	end
end

local function heal(self,target,hp,time,mode)
	time = time or 1
	mode = mode or "random"
	if mode =="random" then
		for i=1,time do
			local num = math.random(1,#target)
			msg.post(target[num].unit, "heal",{hp=hp})
		end
	elseif mode=="less_hp" then
		local hp=3000
		local unit
		for i=1,#target do
			if target[i].hp<hp then
				hp=target[i].hp
				unit=target[i].unit
			end
		end
		msg.post(unit,"heal",{hp=hp})
	elseif mode == "all_character" then
		for i=1,#self.character do
			msg.post(self.character[i].unit, "heal",{hp=hp})
		end
	end
end
local function shield(self,target,shield,time,mode)
	time = time or 1
	mode = mode or "random"
	if mode=="all_character" then
		for i=1,#target do
			msg.post(target[i].unit, "shield",{shield=shield})
		end
	elseif mode=="army" then
		for i = 1, #self.character do
			if self.character[i].id == CHARCTER["군인"] then
				msg.post(self.character[i].unit, "shield",{shield=shield})
				break
			end
		end
	end
end

local function draw()
	msg.post(CARD_MANAGER, "draw")
end


function B.animate_card_effect(self,title)
	if title == TITLE[1] then
	elseif title == TITLE[2] then
	elseif title == TITLE[3] then
	elseif title == TITLE[4] then
	elseif title == TITLE[5] then
	elseif title == TITLE[6] then
	elseif title == TITLE[7] then
	elseif title == TITLE[8] then
	elseif title == TITLE[9] then
	elseif title == TITLE[10] then
	elseif title == TITLE[11] then
	elseif title == TITLE[12] then
	elseif title == TITLE[13] then
	elseif title == TITLE[14] then
	elseif title == TITLE[15] then
	elseif title == TITLE[16] then
	elseif title == TITLE[17] then
	elseif title == TITLE[18] then
	elseif title == TITLE[19] then
	elseif title == TITLE[20] then
	elseif title == TITLE[21] then
	elseif title == TITLE[22] then
	end
	apply_card_effect(self,title)
end

function B.response_card_effect(self, message_id, message, sender)
	if message_id==hash("dead") then
		if self.current_card[#self.current_card].title == TITLE[4] then
			msg.post(CARD_MANAGER, "return_to_deck",self.current_card[#self.current_card])
		end
	end
	if message_id==hash("attack_damage") then
		attack(self, self.enemy, 8, message.time, "random")
	end
	if message_id==hash("draw") then
		for i=1,#self.current_card do
			for j=1,#card do
				if self.current_card[i].title == card[i].title and self.current_card[i].title == TITLE[20] then
					attack(self,self.enemy,10,1,"all_enemy")
					break
				end
			end
		end
		
	end	
end
function apply_effect(self,target,effect)
	if effect == EFFECT[1] then
		for i=1,#target do
			msg.post(target[i].unit, "apply_effect",{type=1})
		end
	end
end
function revive(self)
	local num = math.random(1,#self.dead_character)
	msg.post(self.dead_character[num].unit, "enable")
	msg.post(self.dead_character[num].unit, "heal",{hp=200})
	table.insert(self.character,self.dead_character[num])
end
function set_hp(self,hp)
	for i = 1, #self.character do
		if self.character[i].id == CHARCTER["도박사"] then
			msg.post(self.character[i].unit, "set_hp",{hp=5})
			break
		end
	end
end

function apply_card_effect(self,title)
	if title == TITLE[1] then
		attack(self,self.enemy,5,1,"random")
		draw()
	elseif title == TITLE[2] then
		heal(self,self.character,10,1,"less_hp")
	elseif title == TITLE[3] then
		attack(self,self.enemy,8,1,"not_damaged")
		draw()
	elseif title == TITLE[4] then
		attack(self,self.enemy,15,1,"random")
	elseif title == TITLE[5] then
		attack(self,self.enemy,10,1,"all")
	elseif title == TITLE[6] then
		shield(self,self.character,5,1,"all_character")
		draw()
	elseif title == TITLE[7] then
		apply_effect(self,self.enemy,EFFECT[1])
	elseif title == TITLE[8] then
		heal(self,self.character,30,1,"less_hp")
	elseif title == TITLE[9] then
		attack(self,self.enemy,8,3,"random")
	elseif title == TITLE[10] then
		local damage = 0
		for i = 1, #self.character do
			if self.character[i].id == CHARCTER["군인"] then
				damage=self.character[i].initial_hp-self.character[i].hp
				break
			end
		end
		attack(self,self.enemy,damage,1,"much_hp")
	elseif title == TITLE[11] then
		attack(self,self.enemy,10,1,"all_enemy")
	elseif title == TITLE[12] then
		shield(self,self.character,5,1,"army")
		for i = 1, #self.character do
			if self.character[i].id == CHARCTER["군인"] then
				msg.post(target[i].unit, "apply_effect",{type=2,target=self.character[i].unit})
				break
			end
		end
	elseif title == TITLE[13] then
		heal(self,self.character,10,1,"all_character")
	elseif title == TITLE[14] then
		for i = 1, #self.enemy do
			msg.post(self.enemy[i].unit, "apply_effect",{type=3})
		end
	elseif title == TITLE[15] then
		attack(self,self.enemy,15,1,"all_enemy")
	elseif title == TITLE[16] then
		heal(self,self.character,5,1,"less_hp")
		msg.post(CARD_MANAGER, "return_to_deck",self.current_card[#self.current_card])
	elseif title == TITLE[17] then
		attack(self,self.enemy,10,1,"random")
		attack(self,self.character,10,1,"police")
	elseif title == TITLE[18] then
		msg.post("ingame:/hand", "discard_all")
	elseif title == TITLE[19] then
		revive(self)
	elseif title == TITLE[20] then
		msg.post(CARD_MANAGER, "return_to_deck",self.current_card[#self.current_card])
	elseif title == TITLE[21] then
		set_hp(self,5)
	elseif title == TITLE[22] then
		msg.post(CARD_MANAGER, "use_from_grave")
	end
end

return B