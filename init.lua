--  globals  --

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- globals end --



-- Set up lazy.nvim
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup{
  {
    {
      "catppuccin/nvim",
      lazy = false,
      opts = {
        transparent_background = true,
        flavour = "mocha",
        custom_highlights = function(colors)
          return {
            -- TelescopeBorder = { fg = colors.red, bg = colors.base },
          }
        end
      },
      config = function(_, opts)
        require("catppuccin").setup(opts)

        vim.cmd.colorscheme("catppuccin")
      end,
    },


    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "typescript", "javascript", "html", "css", "go", "python" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
      end
    },



    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
      },
      config = function()
        -- Complete setup inside config function to ensure telescope is loaded
        require('telescope').setup({
          defaults = {
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--hidden" -- Include hidden files
            },
            mappings = {
              i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-h>"] = false,
                ["<C-l>"] = false,
              },
              n = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-h>"] = false,
                ["<C-l>"] = false,
              },
            },
          },
          pickers = {
            colorscheme = {
              enable_preview = true
            },
            find_files = {
              find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
              cwd = vim.fn.expand("%:p:h"), -- Start from the current file's directory
              use_git_root = true, -- This is key - it will traverse up to find the git root
            },
            live_grep = {
              additional_args = function()
                return { "--hidden" }
              end,
              cwd = vim.fn.expand("%:p:h"), -- Start from the current file's directory
              use_git_root = true, -- This is key - it will traverse up to find the git root
            },
            grep_string = {
              cwd = vim.fn.expand("%:p:h"),
              use_git_root = true,
            },
          },
          -- extensions = {
          --   ['ui-select'] = {
          --     require('telescope.themes').get_dropdown(),
          --   },
          -- },
        })

        -- Enable Telescope extensions
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- Function to get git root
        local function get_git_root()
          local current_file = vim.fn.expand("%:p:h")
          local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_file, " ") .. " rev-parse --show-toplevel")[1]
          if vim.v.shell_error ~= 0 then
            return current_file
          end
          return git_root
        end

        -- See `:help telescope.builtin`
        local builtin = require('telescope.builtin')

        -- Define keymaps with git root detection
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })

        -- Override to always use git root
        vim.keymap.set('n', '<leader>pf', function()
          builtin.find_files({ cwd = get_git_root() })
        end, { desc = 'Search Files in Git Root' })

        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

        vim.keymap.set('n', '<leader>sw', function()
          builtin.grep_string({ cwd = get_git_root() })
        end, { desc = '[S]earch current [W]ord in Git Root' })

        vim.keymap.set('n', '<leader>sg', function()
          builtin.live_grep({ cwd = get_git_root() })
        end, { desc = '[S]earch by [G]rep in Git Root' })

        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
            winblend = 0,
            previewer = false,
          }))
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep({
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          })
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files({ cwd = vim.fn.stdpath('config') })
        end, { desc = '[S]earch [N]eovim files' })
      end,
    }

  }
}


---------------
require("options")
