----------------------------------------------------------------------
-- This script demonstrates how to define a couple of different
-- models:
--   + linear
--   + 2-layer neural network (MLP)
--   + convolutional network (ConvNet)
--
-- It's a good idea to run this script with the interactive mode:
-- $ torch -i 2_model.lua
-- this will give you a Torch interpreter at the end, that you
-- can use to play with the model.
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'image'   -- for image transforms
require 'nn'      -- provides all sorts of trainable modules/layers
require 'nngraph'

require 'environment'


print '==> define parameters'
local cmd = torch.CmdLine()
cmd:text()
cmd:text('Options:')
cmd:option('-model', 'convnet', 'type of model to construct: linear | mlp | convnet')
cmd:option('-world_size', 10, 'depth of model')
cmd:option('-steps', 5, 'iterations to take')
cmd:text()
opt = cmd:parse(arg or {})

--local opt = cmd:parse(arg)

-- 10-class problem
noutputs = 10

-- input dimensions
nfeats = 1
width = 10
height = 10
ninputs = nfeats*width*height

-- number of hidden units (for MLP only):
nhiddens = ninputs / 2

-- hidden units, filter sizes (for ConvNet only):
nstates = {32,32,4}
filtsize = 5
poolsize = 2
normkernel = image.gaussian1D(7)



local step = 0
env = environment(opt)
print '==> printing'

-- first start of the game
local observation, reward, terminal = env:getState()


while step < opt.steps do
	step = step + 1
	print('steps: ' .. step)

	-- action
	local answer
	repeat
	   io.write("Movement(Rt: d, Lt: a, Up: w, Down: s)?")
	   io.flush()
	   answer=io.read()
	until answer=="d" or answer=="a" or answer=="w" or answer=="s"

	if answer == 'd' then action_index = (2)
	elseif answer == 'a' then action_index = (1)
	elseif answer == 'w' then action_index = (3)
	elseif answer == 's' then action_index = (4)
	end


	-- observation
    if not terminal then
		observation, reward, terminal = env:step(action_index)
    else
		observation, reward, terminal = env:newGame()
    end

	print('observation')
	print (observation)
	print('reward, ' .. reward .. ', terminal: ') 
	print(terminal)
	print('--- AAAAAA ---')

end

----------------------------------------------------------------------
-- Visualization 
local win = nil --cannot display more then 1 screen

-- display screen
--win = image.display({image=model:get(10).weight, win=win})










