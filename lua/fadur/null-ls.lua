local M = {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	commit = "60b4a7167c79c7d04d1ff48b55f2235bf58158a7",
	dependencies = {
		{
			"nvim-lua/plenary.nvim",
			commit = "9a0d3bf7b832818c042aaf30f692b081ddd58bd9",
			lazy = true,
		},
	},
}
local async_formatting = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

-- format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

function M.config()
	local null_ls = require("null-ls")
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
	local formatting = null_ls.builtins.formatting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
	local diagnostics = null_ls.builtins.diagnostics

	-- https://github.com/prettier-solidity/prettier-plugin-solidity
	null_ls.setup({
		debug = false,
		sources = {
			formatting.prettier.with({
				extra_filetypes = { "toml" },
				extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
			}),
			formatting.black.with({ extra_args = { "--fast", "--line-length", 120 } }),
			formatting.stylua,
			formatting.google_java_format,
			formatting.eslint_d,
			formatting.goimports,
			formatting.gofmt,
			-- elixir formatter
			-- formattint.mix_format,
			diagnostics.flake8,
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				-- vim.api.nvim_del_autocmd( augroup, "BufWritePre" )
				vim.api.nvim_exec("augroup " .. augroup .. "\nautocmd!\naugroup END", false)

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						async_formatting(bufnr)
						-- print "formatting" before formatting
						vim.cmd([[echo "formatting"]])
					end,
				})

				-- filetype html and is Go Templates dont format on save
				if vim.bo.filetype == "html" and vim.bo.filetype == "gotmpl" then
					vim.api.nvim_exec("autocmd! BufWritePre <buffer> lua async_formatting()", false)
				end
			end
		end,
	})
end

return M
