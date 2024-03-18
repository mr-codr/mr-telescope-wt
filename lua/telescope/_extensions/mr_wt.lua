return require("telescope").register_extension({
	setup = function() end,
	exports = {
		mr_wt = require("mr_wt"),
	},
})
