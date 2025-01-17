-- Basic setup for Comment.nvim
-- This sets up default configurations with no additional customizations

require("Comment").setup({
  -- Default mappings for toggling comments
  mappings = {
    basic = true, -- Enables basic keybindings
    extra = false, -- Disables extra keybindings like block comments
  },
  -- No pre-hooks or post-hooks configured for simplicity
  pre_hook = nil,
  post_hook = nil,
})
