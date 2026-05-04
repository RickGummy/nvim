-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
            { "\nPress any key to exit" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
	
    -- catppuccin
    {
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

    -- telescope, fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope: find files" })
            vim.keymap.set("n", "<leader>pg", builtin.git_files, { desc = "Telescope: find git-tracked files" })
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = "Telescope: grep across project" })
            vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "Telescope: grep word under cursor" })
            vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Telescope: open buffers" })
            vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Telescope: search help" })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup({
                ensure_installed = {
                    "c", "cpp", "go", "python", "javascript", "typescript", "java", 
                    "rust", "lua", "vim", "vimdoc", "bash", "json", "yaml", 
                    "html", "css", "markdown", "markdown_inline", "tsx",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

})
