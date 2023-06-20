local ls = require("luasnip")

ls.snippets = {
  all = {
    -- Available in any filetype
  },
  typescriptreact = {
    ls.parser.parse_snippet("sleep", "await new Promise(res => setTimeout(res, $1))$0"),
  },
}
