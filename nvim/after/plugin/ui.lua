local palette = require("onedarker.palette")
vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = palette.gray, ctermfg = 209 })
vim.api.nvim_set_hl(0, "llama_hl_info", { fg = palette.light_gray, ctermfg = 119 })
