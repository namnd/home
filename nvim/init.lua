local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.o.clipboard = 'unnamedplus'
vim.o.mouse = 'nv'
vim.wo.list = true
vim.o.listchars = 'tab:| ,trail:·,eol:↵'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.signcolumn = 'yes:1'
vim.wo.conceallevel = 0
vim.opt.sessionoptions:remove('folds')
vim.o.foldlevel = 10
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.swapfile = false
vim.o.backup = false
vim.o.statusline = "%#AStart# %#AEnd# %#BStart# %#BEnd# %= %#YStart# %#YEnd# %#ZStart# %#ZEnd#"
vim.o.laststatus = 3
vim.o.winbar = "%r%f%m (%n)%= %l:%c (%p%%) %y"
vim.loader.enable()

vim.keymap.set('n', '<leader>zz', ":tabclose<cr>", { noremap = true })
vim.keymap.set("v", "v", "$h", { noremap = true })
vim.keymap.set("n", "E", "ea", { noremap = true })
vim.keymap.set("n", "<leader>rp", "yiwy<esc>:%s/<C-r>+//gc<left><left><left>", { noremap = true })
vim.keymap.set("v", "<leader>rp", "y<esc>:%s/<C-r>+//gc<left><left><left>", { noremap = true })
vim.keymap.set("n", "<leader>,", ":tabedit " .. os.getenv("HOME") .. "/.config/nvim/init.lua<cr>", { noremap = true })
vim.keymap.set("n", "<leader>/", ":tabedit " .. os.getenv("HOME") .. "/.config/home-manager/home.nix<cr>",
  { noremap = true })
vim.keymap.set("n", "<leader>2", function()
  if vim.fn.getqflist({ winid = 0 }).winid == 0 then
    vim.api.nvim_command('lua vim.diagnostic.setqflist()')
  else
    vim.api.nvim_command('cclose')
  end
end, { noremap = true })

vim.filetype.add({
  extension = {
    hujson = "jsonc",
  },
  filename = {
    ["zshrc"] = "bash",
    ["scratch"] = "markdown",
  },
})

-- Notes scratch buffer
local notes_dir = os.getenv("HOME") .. "/notes"
os.execute("mkdir -p " .. notes_dir)
local note_filename = vim.fn.getcwd():gsub("/", "%%")
local note_file = notes_dir .. "/" .. note_filename .. ".md"
local scratch_symlink = vim.fn.getcwd() .. "/scratch"
os.execute("touch " .. note_file)
os.execute("ln -sf " .. note_file .. " " .. scratch_symlink)

vim.api.nvim_create_user_command('S', ":edit " .. scratch_symlink, {})
vim.api.nvim_create_user_command('SS', ":split " .. scratch_symlink, {})
vim.api.nvim_create_user_command('SV', ":vsplit " .. scratch_symlink, {})
vim.api.nvim_create_user_command('ST', ":tabedit " .. scratch_symlink, {})

vim.cmd [[
packadd cfilter
colorscheme namnd
]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  group = augroup('HighlightYankGroup', { clear = true }),
  callback = function() vim.highlight.on_yank({ timeout = 70 }) end,
})

autocmd("BufRead", {
  group = augroup("FiletypeGroup", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "commit" and vim.bo.filetype ~= "gitcommit" and vim.bo.filetype ~= "rebase" and vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd.normal({ 'g`"', bang = true })
    end
  end,
})

autocmd("VimResized", {
  group = augroup("ResizeGroup", { clear = true }),
  callback = function()
    vim.cmd("wincmd =")
  end,
})

autocmd('DiagnosticChanged', {
  callback = function()
    local dc = vim.diagnostic.count(0)
    local dt = {}
    for i, d in ipairs(dc) do
      if i == vim.diagnostic.severity.ERROR then
        dt[i] = " %%#StatusLineDiagnosticError#" .. d .. "%%*"
      end
      if i == vim.diagnostic.severity.WARN then
        dt[i] = " %%#StatusLineDiagnosticWarn#" .. d .. "%%*"
      end
      if i == vim.diagnostic.severity.INFO then
        dt[i] = " %%#StatusLineDiagnosticInfo#" .. d .. "%%*"
      end
      if i == vim.diagnostic.severity.HINT then
        dt[i] = " %%#StatusLineDiagnosticHint#" .. d .. "%%*"
      end
    end

    if #dt > 0 then
      local s = table.concat(dt)
      vim.o.statusline = vim.o.statusline:gsub("%%#YStart#.-%%#YEnd#", "%%#YStart#" .. s .. "%%#YEnd#")
    else
      vim.o.statusline = vim.o.statusline:gsub("%%#YStart#.-%%#YEnd#", "")
    end
  end
})

autocmd('User', {
  group = augroup('GitsignsStatusline', { clear = true }),
  pattern = 'GitSignsUpdate',
  callback = function(args)
    local git_statusline = ""
    local git_status = vim.b[args.buf].gitsigns_status_dict
    if not git_status then
      return
    end

    if git_status.head == "main" or git_status.head == "master" then
      git_statusline = "%%#MainBranch# [Git(" .. git_status.head .. ")]%%*"
    else
      git_statusline = "%%#FeatureBranch#  " .. git_status.head .. "%%*"
    end
    if git_status.added and git_status.added > 0 then
      git_statusline = git_statusline .. "%%#Added# +" .. git_status.added .. "%%*"
    end
    if git_status.removed and git_status.removed > 0 then
      git_statusline = git_statusline .. "%%#Removed# -" .. git_status.removed .. "%%*"
    end
    if git_status.changed and git_status.changed > 0 then
      git_statusline = git_statusline .. "%%#Changed# ~" .. git_status.changed .. "%%*"
    end

    vim.o.statusline = vim.o.statusline:gsub("%%#AStart#.-%%#AEnd#", "%%#AStart#" .. git_statusline .. "%%#AEnd#")
  end
})

require("lazy").setup({
  spec = {
    {
      "tweekmonster/startuptime.vim",
    },
    {
      "mbbill/undotree",
      init = function()
        vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.o.undofile = true
      end,
    },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },
    { "tpope/vim-rhubarb" },
    { "tpope/vim-abolish" },
    {
      "tpope/vim-obsession",
      config = function()
        autocmd('VimEnter', {
          group = augroup('ObsessionCheck', { clear = true }),
          callback = function()
            local status = vim.api.nvim_exec2([[ echo ObsessionStatus() ]], { output = true })
            if status["output"] ~= "[$]" then
              vim.api.nvim_command('silent! Obsession')
            end
          end,
        })
      end
    },
    {
      "tpope/vim-fugitive",
      keys = { { "<leader>gg", ":tab G<cr>" } },
    },
    {
      "junegunn/gv.vim",
      dependencies = "tpope/vim-fugitive",
    },
    {
      "ibhagwan/fzf-lua",
      config = function()
        require("fzf-lua").setup {
          winopts = {
            width = 1,
            height = 0.4,
            row = 1,
            border = 'none',
            backdrop = 50,
          },
        }
      end,
      keys = {
        { "<leader>ff", ":FzfLua files<cr>" },
        { "<leader>fg", ":FzfLua live_grep<cr>" },
        { "<leader>fr", ":FzfLua oldfiles cwd=" .. vim.loop.cwd() .. "<cr>" },
        { "<leader>fs", ":FzfLua live_grep cwd=~/notes<cr>" },
      }
    },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        local gitsigns = require('gitsigns')
        gitsigns.setup {
          on_attach = function(bufnr)
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
              else
                gitsigns.nav_hunk('next')
              end
            end)

            map('n', '[c', function()
              if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
              else
                gitsigns.nav_hunk('prev')
              end
            end)

            map('n', '<leader>hr', gitsigns.reset_hunk)
            map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            map('n', '<leader>hp', gitsigns.preview_hunk)
          end,
        }
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
    },
    {
      "stevearc/oil.nvim",
      opts = {
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            return name == 'Session.vim' or name == '.direnv'
          end,
        },
      },
      keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter.configs').setup {
          modules = {},
          ignore_install = {},
          ensure_installed = { "c", "go", "lua", "vim", "markdown", "json", "jsonc", "nix", "bash", "terraform", "hcl", "sql", "typescript", "tsx", "javascript", "zig" },
          sync_install = false,
          auto_install = false,
          highlight = {
            enable = true,
            disable = function(_, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,
          },
          indent = {
            enable = true,
            disable = { "python" },
          },
        }
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = "nvim-treesitter/nvim-treesitter",
    },
    {
      "AckslD/nvim-trevJ.lua",
      config = true,
      keys = { { "<leader>K", "<cmd>lua require('trevj').format_at_cursor()<cr>" } },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "saghen/blink.cmp" },
        {
          "folke/lazydev.nvim",
          ft = "lua", -- only load on lua files
          opts = {
            library = {
              -- See the configuration section for more details
              -- Load luvit types when the `vim.uv` word is found
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
      },
      opts = {
        servers = {
          bashls = {},
          gopls = {},
          jsonls = {},
          lua_ls = {},
          nixd = {},
          ts_ls = {},
          terraformls = {},
          yamlls = {},
          zls = {},
        },
      },
      config = function(_, opts)
        local lspconfig = require("lspconfig")

        local on_attach = function(_, bufnr)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = bufnr })
        end

        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          config.on_attach = on_attach
          lspconfig[server].setup(config)
        end

        lspconfig.ccls.setup {
          init_options = {
            compilationDatabaseDirectory = "build",
            index = {
              threads = 0,
            },
            clang = {
              excludeArgs = { "-frounding-math" },
            },
          }
        }


        autocmd('LspAttach', {
          callback = function(args)
            local clients = vim.lsp.get_clients({ bufnr = args.buf })

            local ct = {}
            for i, c in pairs(clients) do
              ct[i] = "[" .. c.name .. "]"
            end
            local cs = table.concat(ct)

            vim.o.statusline = vim.o.statusline:gsub("%%#ZStart#.-%%#ZEnd#", "%%#ZStart#" .. cs .. "%%#ZEnd#")

            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end
            if client:supports_method('textDocument/formatting') then
              autocmd('BufWritePre', {
                buffer = args.buf,
                callback = function()
                  vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                end,
              })
            end
          end,
        })
      end,
    },
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod",                     lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      },
      cmd = { "DBUI", "DBUIAddConnection" },
    },
    {
      'saghen/blink.compat',
      version = 'v2.*',
      lazy = true,
      opts = {},
    },
    {
      "saghen/blink.cmp",
      dependencies = "rafamadriz/friendly-snippets",
      version = "v0.*",
      opts = {
        keymap = {
          preset = "default",
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'normal'
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "dadbod", "gh_authors" },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            gh_authors = { name = "gh_authors", module = "blink.compat.source" },
          },
        },
        completion = {
          menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },
        signature = { enabled = true },
      },
    },
  },
})
