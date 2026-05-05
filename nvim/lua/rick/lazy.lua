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
    
        -- Mason
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },

        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "williamboman/mason.nvim" },
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = {
                        "lua_ls",        -- Lua (for editing your nvim config)
                        "pyright",       -- Python
                        "ts_ls",         -- TypeScript / JavaScript
                        "gopls",         -- Go
                        "clangd",        -- C / C++
                    },
                })
            end,
        },

        -- LSP
        -- Mason: installs LSP servers, formatters, linters
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason <-> lspconfig bridge (auto-installs servers we list)
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",        -- Lua (for editing your nvim config)
                    "pyright",       -- Python
                    "ts_ls",         -- TypeScript / JavaScript
                    "gopls",         -- Go
                    "clangd",        -- C / C++
                },
            })
        end,
    },

    -- LSP configurations
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configure each language server with vim.lsp.config (new API)
            local servers = { "lua_ls", "pyright", "ts_ls", "gopls", "clangd" }
            for _, server in ipairs(servers) do
                vim.lsp.config(server, {
                    capabilities = capabilities,
                })
            end

            -- lua_ls needs extra config so it doesn't complain about `vim` being undefined
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- Enable each server (this actually starts them)
            vim.lsp.enable(servers)

            -- LSP keymaps — only active when an LSP attaches to the buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
                    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
                end,
            })
        end,
    },

    -- Completion engine
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
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
