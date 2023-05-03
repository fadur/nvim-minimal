local M = {
	"goolord/alpha-nvim",
	event = "VimEnter",
	commit = "dafa11a6218c2296df044e00f88d9187222ba6b0",
}

function M.config()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")
	dashboard.section.header.val = {

		[[ .----------------.  .----------------.  .----------------.  .----------------.  .----------------.]],
		[[| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |]],
		[[| |  _________   | || |      __      | || |  ________    | || | _____  _____ | || |  _______     | |]],
		[[| | |_   ___  |  | || |     /  \     | || | |_   ___ `.  | || ||_   _||_   _|| || | |_   __ \    | |]],
		[[| |   | |_  \_|  | || |    / /\ \    | || |   | |   `. \ | || |  | |    | |  | || |   | |__) |   | |]],
		[[| |   |  _|      | || |   / ____ \   | || |   | |    | | | || |  | '    ' |  | || |   |  __ /    | |]],
		[[| |  _| |_       | || | _/ /    \ \_ | || |  _| |___.' / | || |   \ `--' /   | || |  _| |  \ \_  | |]],
		[[| | |_____|      | || ||____|  |____|| || | |________.'  | || |    `.__.'    | || | |____| |___| | |]],
		[[| |              | || |              | || |              | || |              | || |              | |]],
		[[| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |]],
		[[ '----------------'  '----------------'  '----------------'  '----------------'  '----------------' ]],
	}
	dashboard.section.buttons.val = {
		dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
		dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button(
			"p",
			" " .. " Find project",
			":lua require('telescope').extensions.projects.projects()<CR>"
		),
		dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
		dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
		dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
		dashboard.button("q", " " .. " Quit", ":qa<CR>"),
	}
	local function footer()
		return "novonordisk.com"
	end

	dashboard.section.footer.val = footer()

	dashboard.section.footer.opts.hl = "Type"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.opts.opts.noautocmd = true
	alpha.setup(dashboard.opts)
end

return M
