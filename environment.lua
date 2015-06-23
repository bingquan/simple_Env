-- The environment class.
local environment = torch.class('environment')

function environment:__init(_opt)
	local _opt = _opt or {}

	self.contents ="noob man!"
	self.world = torch.Tensor(1,_opt.world_size)
	self.world_state = torch.random(2) -- 1 = 'up' or 2 = 'down'

	self.position = 1
	self.prev_position = 1
	self.world[1][self.position] = 1

	self.world_size = _opt.world_size

	self.observation = torch.Tensor(5)  
	self.observation[1] = 0
	self.observation[2] = 1
	self.observation[3] = 1 -- up
	self.observation[4] = 1 -- down
	if self.world_state == 1 then -- up
		self.observation[5] = 1
	else
		self.observation[5] = 2 --down
	end

	print(self.world)
	-- print(self.observation)
	print('world_state: '.. self.world_state)
	

	self.terminal = false	
	self.reward = 0

	-- 1 to Look Left
	-- 2 to Look Right
	-- 3 to Look Up
	-- 4 to Look down
	-- 5 flag of up or down

	return self
end

function environment:print()
	print(self.world)--self.world)
	print(self.position)
end


-- Input: action => Environment => update: curr_state, output: rewards

--[[function environment:getState()

end]]--

function environment:getState()
	return self.observation, self.reward, self.terminal 
end

function environment:newGame()
	self.world = torch.Tensor(1,self.world_size)
	self.world_state = torch.random(2) -- 1 = 'up' or 2 = 'down'
	self.position = 1
	self.prev_position = 1
	self.world[1][self.position] = 1

	self.observation = torch.Tensor(5)  
	self.observation[1] = 0
	self.observation[2] = 1
	self.observation[3] = 1 -- up
	self.observation[4] = 1 -- down
	if self.world_state == 1 then -- up
		self.observation[5] = 1
	else
		self.observation[5] = 2 --down
	end
	print(self.world)
	-- print(self.observation)
	print('world_state: '.. self.world_state)

	self.terminal = false	
	self.reward = 0

	return self.observation, self.reward, self.terminal 

end

function environment:step(action)
	-- 1 to move Left
	-- 2 to move Right
	-- 3 to move Up
	-- 4 to move down

	self.reward = 0
	print("action: ".. action)

	self.world[1][self.prev_position] = 0

	if action == 1 then
		self.position = self.position - 1
		if self.position < 1 then 
			self.position = 1	
		end

	elseif action == 2 then
		self.position = self.position + 1
		if self.position > self.world_size then 
			self.position = self.world_size	
		end

	elseif action == 3 then -- UP
		if self.position == self.world_size	then
			self.terminal = true
			if self.world_state == 1 then
				self.reward = 4
			else
				self.reward = -1
			end
		end

	elseif action == 4 then -- DOWN
		if self.position == self.world_size	then
			self.terminal = true
			if self.world_state == 2 then
				self.reward = 4
			else
				self.reward = -1
			end
		end
	end 

	self.world[1][self.position] = 1
	self.prev_position = self.position


	--observation of agent
	if self.position == 1 then
		self.observation[1] = 0
		self.observation[2] = 1
		self.observation[3] = 1 -- up
		self.observation[4] = 1 -- down
		if self.world_state == 1 then -- up
			self.observation[5] = 1
		else
			self.observation[5] = 2 --down
		end

	elseif self.position == self.world_size then
		self.observation[1] = 1
		self.observation[2] = 0
		self.observation[3] = 0
		self.observation[4] = 0
		self.observation[5] = 0
	else 
		self.observation[1] = 0
		self.observation[2] = 0
		self.observation[3] = 1
		self.observation[4] = 1
		self.observation[5] = 0
	end


	--self.observation = 


	print(self.world)
	-- print(self.observation)
	print('world_state: '.. self.world_state)


	return self.observation, self.reward, self.terminal 

end
