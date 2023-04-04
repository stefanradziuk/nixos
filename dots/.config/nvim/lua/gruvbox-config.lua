local contrast = "hard"
local colors = require("gruvbox.palette").get_base_colors(vim.o.background, contrast)

colors["dark0_hard"] = "#1d2021"
colors["dark0"] = "#282828"
colors["dark0_soft"] = "#32302f"

-- setup must be called before loading the colorscheme
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = contrast, -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    CoqtailChecked    = {bg = colors.dark0_soft},
    CoqtailSent       = {bg = colors.neutral_purple},

    GitGutterAdd      = {fg = colors.green},
    GitGutterChange   = {fg = colors.yellow},
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
