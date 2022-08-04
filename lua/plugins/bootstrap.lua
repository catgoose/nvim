local fn = vim.fn
local utils = require("config.utils")
local cmd = vim.cmd
local packer_install_path = utils.packer_install_path
local packer_config = utils.packer_config
local bootstrap = false

if fn.empty(fn.glob(packer_install_path)) > 0 then
	bootstrap = true
	fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_install_path,
	})
end

cmd.packadd("packer.nvim")
local packer_ok, packer = pcall(require, "packer")

if packer_ok then
	packer.init(packer_config(bootstrap))
else
	error("Error while cloning packer to " .. packer_install_path .. "\n" .. packer)
end

return packer
