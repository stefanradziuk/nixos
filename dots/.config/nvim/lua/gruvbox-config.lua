local contrast = "hard"
local colors = require("gruvbox.palette").get_base_colors(vim.o.background, contrast)

-- setup must be called before loading the colorscheme
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = contrast, -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    CoqtailChecked    = {bg = colors.bg2},
    CoqtailSent       = {bg = colors.bg1},

    GitGutterAdd      = {fg = colors.yellow},
    GitGutterChange   = {fg = colors.green},
    GitGutterDelete   = {fg = colors.red},

    GruvboxAquaSign   = {bg = colors.bg0},
    GruvboxBlueSign   = {bg = colors.bg0},
    GruvboxGreenSign  = {bg = colors.bg0},
    GruvboxOrangeSign = {bg = colors.bg0},
    GruvboxPurpleSign = {bg = colors.bg0},
    GruvboxRedSign    = {bg = colors.bg0},
    GruvboxYellowSign = {bg = colors.bg0},

    SignColumn        = {bg = colors.bg0},
    StatusLine        = {fg = colors.bg0},
    StatusLineNC      = {fg = colors.bg0},
    TabLine           = {bg = colors.bg0},
    TabLineFill       = {bg = colors.bg0},
    TabLineSel        = {bg = colors.bg0},
    Title             = {bg = colors.bg0},
  },
  dim_inactive = false,
  transparent_mode = false,
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
