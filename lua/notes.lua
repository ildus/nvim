local M = {}
local fzf_lua_ok, fzf_lua = pcall(require, 'fzf-lua')

-- unpack is going to be deprecated soon
local table_unpack = table.unpack or unpack -- 5.1 compatibility

if not fzf_lua_ok or not fzf_lua.live_grep then
  function M.search_notes()
    vim.notify("fzf-lua or fzf-lua.live_grep could not be loaded. Please ensure fzf-lua is correctly installed and updated.")
  end

  return M
end

local rg_options = {
  '--no-messages',
  '--no-heading',    -- Don't print the initial summary
  '--with-filename', -- Print the filename for each match
  '--follow',        -- Follow symbolic links
  '--smart-case',    -- Search case-insensitively unless query contains uppercase
  '--line-number',   -- Print the line number for each match
  '--color=never',   -- Disable ripgrep's colors; fzf will handle colors
}

local fzf_options = {
  ['--ansi'] = '',  -- Interpret ANSI color codes (though rg --color=never should prevent them)
  ['--multi'] = '', -- Allow selecting multiple items with Tab
  ['--info'] = 'inline',
  ['--tiebreak'] = 'length,begin',
}

local function create_new_note(selected, _)
  local query = fzf_lua.get_last_query()

  if #vim.g.notes_path == 0 then
      return
  end

  local main_dir = vim.g.notes_path[1]
  local note_name = vim.fn.fnameescape(main_dir .. "/" .. query:gsub("[ ]+", "_") .. ".md")

  vim.cmd("edit " .. note_name)
end

function M.search_notes()
  if #vim.g.notes_path == 0 then
      return
  end

  fzf_lua.live_grep({
    prompt = 'Search> ',
    grep_cmd = "rg",
    grep_opts = table.concat(rg_options, " "),
    search_paths = vim.g.notes_path,
    actions = {
      ['default'] = require('fzf-lua.actions').file_jump,
      ["ctrl-n"] = create_new_note,
    },

    fzf_opts = fzf_options,
  })
end

return M
