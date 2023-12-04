local configs = require("dropbar.configs")
local bar = require("dropbar.bar")
local plenary = require("plenary")

---Get icon, icon highlight and name highlight of a path
---@param path string
---@return string icon
---@return string? icon_hl
---@return string? name_hl
local function get_icon_and_hl(path)
  local icon = configs.opts.icons.kinds.symbols.File
  local icon_hl = "DropBarIconKindFile"
  local name_hl = "DropBarKindFile"
  local stat = vim.loop.fs_stat(path)
  if not stat then
    return icon, icon_hl
  elseif stat.type == "directory" then
    icon = configs.opts.icons.kinds.symbols.Folder
    icon_hl = "DropBarIconKindFolder"
    name_hl = "DropBarKindFolder"
  end
  if configs.opts.icons.kinds.use_devicons then
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    if devicons_ok and stat and stat.type ~= "directory" then
      local devicon, devicon_hl =
        devicons.get_icon(vim.fs.basename(path), vim.fn.fnamemodify(path, ":e"), { default = true })
      icon = devicon and devicon .. " " or icon
      icon_hl = devicon_hl
    end
  end
  return icon, icon_hl, name_hl
end

---Convert a path to a dropbar symbol
---@param path string full path
---@param buf integer buffer handler
---@param win integer window handler
---@return dropbar_symbol_t
local function convert(path, buf, win, label)
  local icon, icon_hl, name_hl = get_icon_and_hl(path)

  return bar.dropbar_symbol_t:new(setmetatable({
    buf = buf,
    win = win,
    name = label or path,
    icon = icon,
    name_hl = name_hl,
    icon_hl = icon_hl,
    ---Override the default jump function
    jump = function(_)
      require("nvim-tree")
      local api = require("nvim-tree.api")
      api.tree.find_file({ buf = path, focus = false })
      vim.cmd.edit(path)
    end,
  }, {
    ---@param self dropbar_symbol_t
    __index = function(self, k)
      if k == "children" then
        self.children = {}
        local count = 0
        for name in vim.fs.dir(path) do
          if configs.opts.sources.path.filter(name) then
            table.insert(self.children, convert(path .. "/" .. name, buf, win, name))
            count = count + 1
          end
        end

        if count > 0 then
          table.insert(self.children, 1, convert(vim.fs.dirname(path), buf, win, ".."))
        end

        return self.children
      end
      if k == "siblings" or k == "sibling_idx" then
        local count = 0
        local parent_dir = vim.fs.dirname(path)
        self.siblings = {}
        self.sibling_idx = 1

        for idx, name in vim.iter(vim.fs.dir(parent_dir)):enumerate() do
          if configs.opts.sources.path.filter(name) then
            table.insert(self.siblings, convert(parent_dir .. "/" .. name, buf, win, name))
            count = count + 1
            if name == self.name then
              self.sibling_idx = idx
            end
          end
        end

        if count > 0 then
          table.insert(self.siblings, 1, convert(vim.fs.dirname(parent_dir), buf, win, ".."))
        end

        return self[k]
      end
    end,
  }))
end

---Get list of dropbar symbols of the parent directories of given buffer
---@param buf integer buffer handler
---@param win integer window handler
---@param _ integer[] cursor position, ignored
---@return dropbar_symbol_t[] dropbar symbols
local function get_symbols(buf, win, _)
  local symbols = {} ---@type dropbar_symbol_t[]
  local current_path = vim.fs.normalize(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:."))

  table.insert(
    symbols,
    1,
    convert(current_path, buf, win, plenary.path:new(vim.api.nvim_buf_get_name(buf)):make_relative())
  )
  if vim.bo[buf].mod then
    symbols[#symbols] = configs.opts.sources.path.modified(symbols[#symbols])
  end
  return symbols
end

return {
  get_symbols = get_symbols,
}
