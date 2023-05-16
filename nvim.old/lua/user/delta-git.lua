local M = {}
local previewers = require "telescope.previewers"
local builtin = require "telescope.builtin"

M.git_commits = function(opts)
  opts = opts or {}
  opts.previewer = {
    previewers.new_termopen_previewer {
      get_command = function(entry)
        return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value .. "^!" }
      end,
    },
    previewers.git_commit_message.new(opts),
    previewers.git_commit_diff_as_was.new(opts),
  }
  builtin.git_commits(opts)
end

M.git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = {
    previewers.new_termopen_previewer {
      get_command = function(entry)
        return {
          "git",
          "-c",
          "core.pager=delta",
          "-c",
          "delta.side-by-side=false",
          "diff",
          entry.value .. "^!",
          "--",
          entry.current_file,
        }
      end,
    },
    previewers.git_commit_message.new(opts),
    previewers.git_commit_diff_as_was.new(opts),
  }
  builtin.git_bcommits(opts)
end

M.git_status = function(opts)
  opts = opts or {}
  opts.previewer = {
    previewers.new_termopen_previewer {
      get_command = function(entry)
        return {
          "git",
          "-c",
          "core.pager=delta",
          "-c",
          "delta.side-by-side=false",
          "diff",
          "HEAD",
          "--",
          entry.value,
        }
      end,
    },

    previewers.git_file_diff.new(opts),
  }
  builtin.git_status(opts)
end

return M
