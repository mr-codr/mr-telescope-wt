local function normalizePathSep(path)
	local sep = require("plenary.path").path.sep
	local reversedSep
	if sep == "/" then
		reversedSep = [[\]]
	else
		reversedSep = "/"
	end
	return string.gsub(path, reversedSep, sep)
end

local M = {}

M.isPath = function(value)
	local index = string.find(value, "worktree", 1, true)
	return index == 1
end

M.getPath = function(value)
	value = normalizePathSep(value)
	return string.sub(value, 10)
end

M.isHash = function(value)
	local index = string.find(value, "HEAD", 1, true)
	return index == 1
end

M.getHash = function(value)
	return string.sub(value, 6)
end

M.isBranch = function(value)
	local index = string.find(value, "branch", 1, true)
	return index == 1
end

M.getBranch = function(value)
	return string.sub(value, 19)
end

M.format = function(worktree)
	if worktree.isBareRoot then
		return worktree.path .. " (bare root)"
	end
	local shotHash = string.sub(worktree.hash, 1, 8)
	return worktree.branch .. " [" .. shotHash .. "]"
end

M.getOrdinal = function(worktree)
	if worktree.isBareRoot then
		return 0
	end
	return worktree.branch
end

return M
