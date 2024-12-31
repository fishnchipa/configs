require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = {
        -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = true, -- Force no italic
    no_bold = false,  -- Force no bold
    styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        fidget = true,
        markdown = true,
        mason = true,
        dap = {
            enabled = true,
            enabled_ui = true,
        },
        indent_blankline = {

            enabled = true,
            colored_indent_levels = true,
        },
        which_key = true,
    },
})



vim.cmd.colorscheme('catppuccin')
