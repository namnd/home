local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  return
end

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

telescope.setup({
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      width = 170,
      preview_width = 0.6,
    },
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<esc>"] = actions.close,
        ["<C-p>"] = action_layout.toggle_preview,
      }
    },
    preview = {
      hide_on_startup = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    recent_files = {
      only_cwd = true,
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
    },
  },
})

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'recent_files')
pcall(require('telescope').load_extension, 'live_grep_args')

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>', {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fr', '<cmd>lua require("telescope").extensions.recent_files.pick()<cr>', {})
