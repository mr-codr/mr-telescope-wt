local u = require("mr_wt.utils")

---expected entry table format:
---```lua
---  {
---    "worktree C:/Users/me/my_project",
---    "HEAD 5eafc128720001956318813f1ad0d1f70f03d976",
---    "branch refs/heads/master",
---  },
---```
---result:
---```lua
--- {
---   value = {
---     path = 'C:\\Users\\me\\my_project',
---     hash = '5eafc128720001956318813f1ad0d1f70f03d976',
---     branch = 'master',
---   },
---   display = 'master [5eafc12]',
---   ordinal = 'master'
---  },
---```
---@param entry table
---@return table
local function wtEntryMaker(entry)
	local worktree = {}
	for _, line in pairs(entry) do
		if u.isPath(line) then
			worktree.path = u.getPath(line)
		elseif u.isHash(line) then
			worktree.hash = u.getHash(line)
		elseif u.isBranch(line) then
			worktree.branch = u.getBranch(line)
		end
	end

	return {
		value = worktree,
		display = u.format(worktree),
		ordinal = worktree.branch,
	}
end

return wtEntryMaker
