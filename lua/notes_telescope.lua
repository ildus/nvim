local M = {}

-- Check for Telescope and its necessary components
local telescope_ok, telescope = pcall(require, 'telescope')
local telescope_actions_ok, actions = pcall(require, 'telescope.actions')
local telescope_actions_state_ok, actions_state = pcall(require, 'telescope.actions.state')
local telescope_builtin_ok, builtin = pcall(require, 'telescope.builtin')
local telescope_config_ok, telescope_config = pcall(require, 'telescope.config')

if not (telescope_ok and telescope_actions_ok and telescope_actions_state_ok and telescope_builtin_ok and telescope_config_ok) then
  function M.search_notes()
    vim.notify("Telescope or its components could not be loaded. Please ensure Telescope is correctly installed.",
      vim.log.levels.ERROR)
  end

  return M
end

-- Function to create a new note, adapted for Telescope
local function create_new_note_telescope(prompt_bufnr)
  local query = actions_state.get_current_prompt_value(prompt_bufnr)

  if not query or query:match("^%s*$") then -- Check if query is nil, empty or only whitespace
    vim.notify("Cannot create a note with an empty name.", vim.log.levels.WARN)
    -- We don't close the picker here, user might want to type a new name
    return
  end

  if not vim.g.notes_path or #vim.g.notes_path == 0 then
    vim.notify("vim.g.notes_path is not set or is empty.", vim.log.levels.ERROR)
    actions.close(prompt_bufnr) -- Close the Telescope picker as we can't proceed
    return
  end

  local main_dir = vim.g.notes_path[1] -- Assuming the first path is the primary one for new notes

  -- Sanitize the query to be a valid filename:
  -- 1. Replace spaces with underscores.
  -- 2. Remove characters not typically allowed or safe in filenames.
  --    Allows alphanumeric, underscore, hyphen, dot.
  local note_filename = query:gsub("[ ]+", "_"):gsub("[^%w_.-]", "")

  if note_filename == "" then
    vim.notify("Invalid note name after sanitization (original: \"" .. query .. "\"). Please use valid characters.",
      vim.log.levels.ERROR)
    -- Don't close, let user try again or clear prompt
    return
  end

  local note_path = vim.fn.fnameescape(main_dir .. "/" .. note_filename .. ".md")

  -- Close Telescope picker before opening the new note
  actions.close(prompt_bufnr)

  -- Schedule opening the new note to ensure Telescope has fully closed
  vim.schedule(function()
    vim.cmd("edit " .. note_path)
    vim.notify("Created and opened new note: " .. note_path, vim.log.levels.INFO)
  end)
end

function M.search_notes()
  if not vim.g.notes_path or #vim.g.notes_path == 0 then
    vim.notify("vim.g.notes_path is not set or is empty. Cannot search notes.", vim.log.levels.WARN)
    return
  end

  -- Additional rg flags we want to ensure are used.
  -- Telescope's live_grep already includes sensible defaults like:
  -- --column, --line-number, --no-heading, --color=never, --smart-case
  local custom_rg_flags = {
    '--no-messages', -- Suppress "skipped X files" messages from rg
    '--follow',      -- Follow symbolic links
  }

  -- Combine our custom flags with Telescope's default vimgrep_arguments
  -- Note: `telescope_config.values.vimgrep_arguments` are the *defaults configured for telescope*.
  -- If the user has overridden `vimgrep_arguments` in their telescope setup for `live_grep`,
  -- this direct merge might not be what they expect for *all* live_grep instances.
  -- However, for a picker-specific override, this is a common pattern.
  local vimgrep_args = vim.list_extend(
    vim.deepcopy(telescope_config.values.vimgrep_arguments),
    custom_rg_flags
  )
  -- Remove duplicates if any, ensuring custom_rg_flags take precedence or are added if not present.
  -- A simple way is to convert to a set and back, or iterate. For few flags, manual check is fine.
  -- This simple extend might lead to duplicates if custom_rg_flags contain items already in defaults.
  -- A more robust merge would check for existence before adding.
  -- For these specific flags, they are unlikely to be in the defaults in a conflicting way.

  builtin.live_grep({
    prompt_title = 'Search Notes',
    search_dirs = vim.g.notes_path,
    vimgrep_arguments = vimgrep_args,

    attach_mappings = function(prompt_bufnr, map)
      -- Default action (Enter) is `actions.select_default`, which opens the file and jumps.
      -- This matches the original fzf-lua behavior of `require('fzf-lua.actions').file_jump`.

      -- Map "ctrl-n" to create a new note based on the current prompt input
      map('i', '<C-n>', function()
        create_new_note_telescope(prompt_bufnr)
      end)
      map('n', '<C-n>', function() -- Also map for normal mode in the prompt
        create_new_note_telescope(prompt_bufnr)
      end)

      return true -- Essential to apply the mappings
    end,
    -- Additional Telescope options can be configured here if needed, for example:
    -- layout_strategy = 'horizontal',
    -- layout_config = { preview_width = 0.55 },
    -- sorting_strategy = 'ascending',
    -- previewer = require('telescope.previewers').vim_buffer_cat.new({}),
  })
end

return M
