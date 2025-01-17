local contrast = "hard"
local colors = require("gruvbox").palette

colors["dark0_hard"] = "#1d2021"
colors["dark0"] = "#282828"
colors["dark0_soft"] = "#32302f"

-- see https://github.com/ellisonleao/gruvbox.nvim/issues/306
local bg0 = colors.dark0_hard

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
  palette_overrides = {
    dark0_hard = "#1d2021",
    dark0 = "#282828",
    dark0_soft = "#32302f",
  },
  overrides = {
    CoqtailChecked    = {bg = colors.dark0_soft},
    CoqtailSent       = {bg = colors.neutral_purple},

    GitGutterAdd      = {fg = colors.neutral_green},
    GitGutterChange   = {fg = colors.neutral_yellow},
    GitGutterDelete   = {fg = colors.neutral_red},

    GruvboxAquaSign   = {bg = bg0},
    GruvboxBlueSign   = {bg = bg0},
    GruvboxGreenSign  = {bg = bg0},
    GruvboxOrangeSign = {bg = bg0},
    GruvboxPurpleSign = {bg = bg0},
    GruvboxRedSign    = {bg = bg0},
    GruvboxYellowSign = {bg = bg0},

    LineNr            = {bg = bg0},
    CursorLineNr      = {bg = bg0},

    SignColumn        = {bg = bg0},
    StatusLine        = {fg = bg0},
    StatusLineNC      = {fg = bg0},
    TabLine           = {bg = bg0},
    TabLineFill       = {bg = bg0},
    TabLineSel        = {bg = bg0},
    Title             = {bg = bg0},
  },
  dim_inactive = false,
  transparent_mode = false,
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
