return   {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "c",
                    "lua",
                    "rust",
                    "haskell",
                    "vimdoc",
                    "typescript",
                    "tsx",
                    "html",
                    "markdown",
                    "markdown_inline",
                    "python"
                },
                highlight = { enable = true, }
            }
        end
    },

    {
        "windwp/nvim-ts-autotag",
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false -- Auto close on trailing </
                },
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },

        config = function()
            local actions = require("telescope.actions")
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                            ["<C-j>"] = actions.move_selection_next, -- move to next result
                            ["<esc>"] = actions.close
                        }
                    }
                }
            })
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end

    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local luasnip = require("luasnip")
            local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                experimental = {
                    ghost_text = true
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                    ["<C-CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp"},
                    { name = "luasnip" }, -- snippets
                    { name = "buffer" }, -- text within current buffer
                    { name = "path" }, -- file system paths
                }),

            })
            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "eslint",
                    "tsserver",
                    "tailwindcss",
                    "pyright"
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,
                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,

                    ["eslint"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.eslint.setup {
                            on_attach = function(client, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    command = "EslintFixAll",
                                })

                                vim.api.nvim_buf_create_user_command(bufnr, 'EslintFixAll', function()
                                    vim.lsp.buf.execute_command({
                                        command = "eslint.applyAllFixes",
                                        arguments = { { uri = vim.uri_from_bufnr(bufnr) } }
                                    })
                                end, { desc = 'Fix all ESLint issues' })
                            end,
                            handlers = {
                                ['language/status'] = function(_, result)
                                    -- Print or whatever.
                                end,
                                ['$/progress'] = function(_, result, ctx)
                                    -- disable progress updates.
                                end,

                                ['window/showMessage'] = function(_, result)
                                  -- Optionally, print messages that are not related to progress
                                end
                            },
                        }
                    end,

                    ["tsserver"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.tsserver.setup({

                            handlers = {
                                ['language/status'] = function(_, result)
                                    -- Print or whatever.
                                end,
                                ['$/progress'] = function(_, result, ctx)
                                    -- disable progress updates.
                                end,

                                ['window/showMessage'] = function(_, result)
                                  -- Optionally, print messages that are not related to progress
                                end
                            },

                        })
                    end,

                    ["tailwindcss"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.tailwindcss.setup({})
                    end,

                    ["html"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.html.setup({})
                    end,

                    ["pyright"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.pyright.setup({})
                    end,
                }



            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},

        config = function()
            local dap = require 'dap'

            local dapui = require 'dapui'

            dapui.setup()

            vim.api.nvim_set_hl(0, "DapUIVariable", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIValue", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIFrameName", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIFrameName", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIScope", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIType", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIWatches", { bg = "none" })
            vim.api.nvim_set_hl(0, "DapUIBreakpoints", { bg = "none" })

            dap.listeners.after.launch.dapui_config = function()
                require('dapui').open()
            end

            vim.keymap.set('n', '<leader>do', function()
                require('dapui').open()
            end)

            vim.keymap.set('n', '<leader>dc', function()
                require('dapui').open()
                require('dapui').close()
            end)
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        view = { adaptive_size = true },
        config = function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"
                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set('n', '<leader>t', api.tree.toggle)
                vim.keymap.set('n', '<leader>f', api.tree.open)
            end
            require("nvim-tree").setup({
                on_attach = my_on_attach
            })
        end,
    }
}





