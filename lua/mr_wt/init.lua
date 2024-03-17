local Path = require("plenary.path")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local getWtEntries = require("mr_wt.get-wt-entries")
local wtEntryMaker = require("mr_wt.wt-entry-maker")

return function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Worktrees",
			finder = finders.new_table({
				results = getWtEntries(),
				entry_maker = wtEntryMaker,
			}),
			sorter = config.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local selectedWtPath = selection.value.path

					if selection.value.isBareRoot then
						print("Can't go to bare repo root")
						return
					end

					local currentBuf = vim.api.nvim_get_current_buf()
					local isModified = vim.api.nvim_buf_get_option(currentBuf, "modified")
					if isModified then
						print("modified buffer. Not changing directory")
						return
					end

					local currentBufPath = vim.api.nvim_buf_get_name(currentBuf)
					local currentBufRelativePath = Path:new(currentBufPath):make_relative()
					local currentBufPathInSelectedWt = Path:new(selectedWtPath, currentBufRelativePath)

					vim.api.nvim_buf_delete(currentBuf, {})
					vim.cmd(":cd " .. selectedWtPath)
					if Path:new(currentBufPathInSelectedWt):exists() then
						vim.cmd(":edit " .. currentBufPathInSelectedWt.filename)
					end
					vim.cmd(":clearjumps")
				end)
				return true
			end,
		})
		:find()
end
