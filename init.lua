local utils = require("config.utils")
local load_nvim_config = utils.load_nvim_config
local packer_compile_done = utils.packer_compile_done

local impatient_ok, impatient = pcall(require, "impatient")
local packer_ok, packer = pcall(require, "plugins")
if not packer_ok or not packer then
	return
end

if impatient_ok then
	impatient.enable_profile()
else
	packer_compile_done()
	packer.sync()
end

load_nvim_config()
