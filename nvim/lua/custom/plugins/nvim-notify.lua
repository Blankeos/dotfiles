return {
	'rcarriga/nvim-notify',
	config = function()
		require('notify').setup({
			render = 'compact',
			top_down = false,
		})
	end,
}
