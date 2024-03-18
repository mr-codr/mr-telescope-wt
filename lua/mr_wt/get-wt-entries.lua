---Returns the results of the command `git worktree list --porcelain` formatted into a list of lists
---Return example:
---```lua
---{
---  {
---    "worktree C:/Users/me/my_project",
---    "HEAD 5eafc128720001956318813f1ad0d1f70f03d976",
---    "branch refs/heads/master",
---  },
---  {
---    "worktree C:/Users/me/my_project",
---    "HEAD 44a3094278e73ec5dbdefc5bc59da0c35637e1d4",
---    "branch refs/heads/test",
---  },
---}
---```
---if the command errors, returns `nil`
---@return table|nil
local getWtEntries = function()
	local command = "git worktree list --porcelain"
	local handle = io.popen(command)

	if handle == nil then
		print("could not run command:" .. command)
		return
	end

	local worktrees = {}
	local currentWorktree = {}
	for line in handle:lines() do
		if line ~= "" then
			table.insert(currentWorktree, line)
		else
			table.insert(worktrees, currentWorktree)
			currentWorktree = {}
		end
	end
	handle:close()

	if worktrees[1][2] == "bare" then
		table.remove(worktrees, 1)
	end
	return worktrees
end

return getWtEntries
