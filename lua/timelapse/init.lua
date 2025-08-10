local M = {}

local config = {
  wpm = 300,
  show_cursor = true,
  preserve_original = true,
}

local state = {
  is_running = false,
  is_paused = false,
  timer = nil,
  original_content = {},
  current_pos = 1,
  target_buffer = nil,
  keymap_id = nil,
}

local function calculate_delay_ms(wpm)
  local chars_per_minute = wpm * 5
  local chars_per_second = chars_per_minute / 60
  local delay_seconds = 1 / chars_per_second
  return math.floor(delay_seconds * 1000)
end

local function get_buffer_text()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(lines, '\n')
end

local function clear_buffer()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

local function type_next_chunk()
  if not state.is_running or state.is_paused then
    return
  end

  local text = table.concat(state.original_content, '')

  if state.current_pos > #text then
    M.stop()
    return
  end

  -- Find next word boundary or significant whitespace
  local next_pos = state.current_pos
  local char = string.sub(text, next_pos, next_pos)

  if char:match '%s' then
    -- If we're at whitespace, consume all contiguous whitespace
    while next_pos <= #text and string.sub(text, next_pos, next_pos):match '%s' do
      next_pos = next_pos + 1
    end
  else
    -- If we're in a word, consume the whole word
    while next_pos <= #text and not string.sub(text, next_pos, next_pos):match '%s' do
      next_pos = next_pos + 1
    end
  end

  local current_text = string.sub(text, 1, next_pos - 1)
  local new_lines = vim.split(current_text, '\n', { plain = true })
  local old_lines = vim.api.nvim_buf_get_lines(state.target_buffer, 0, -1, false)

  -- Only update lines that have actually changed
  local lines_to_update = math.max(#new_lines, #old_lines)

  if #new_lines > #old_lines then
    -- Add new lines
    vim.api.nvim_buf_set_lines(state.target_buffer, #old_lines, #old_lines, false, vim.list_slice(new_lines, #old_lines + 1))
  elseif #new_lines < #old_lines then
    -- Remove excess lines
    vim.api.nvim_buf_set_lines(state.target_buffer, #new_lines, #old_lines, false, {})
  end

  -- Update only the last line that changed
  if #new_lines > 0 then
    local last_new_line = new_lines[#new_lines]
    local last_old_line = #old_lines > 0 and old_lines[math.min(#new_lines, #old_lines)] or ''

    if last_new_line ~= last_old_line then
      vim.api.nvim_buf_set_lines(state.target_buffer, #new_lines - 1, #new_lines, false, { last_new_line })
    end
  end

  state.current_pos = next_pos

  local last_line = #new_lines
  local last_col = #new_lines[last_line]
  vim.api.nvim_win_set_cursor(0, { last_line, last_col })

  vim.cmd 'redraw'

  state.timer = vim.defer_fn(type_next_chunk, calculate_delay_ms(config.wpm))
end

function M.start()
  if state.is_running then
    print 'TimeLapse is already running'
    return
  end

  state.target_buffer = vim.api.nvim_get_current_buf()
  local text = get_buffer_text()

  if text == '' then
    print 'Buffer is empty'
    return
  end

  state.original_content = { text }
  state.current_pos = 1
  state.is_running = true
  state.is_paused = false

  if config.preserve_original then
    vim.api.nvim_buf_set_option(state.target_buffer, 'modified', false)
  end

  clear_buffer()

  -- Set up 'q' key mapping to cancel
  vim.keymap.set('n', 'q', M.stop, {
    buffer = state.target_buffer,
    desc = 'Cancel TimeLapse',
    nowait = true,
  })

  print(string.format("Starting TimeLapse at %d WPM (press 'q' to cancel)", config.wpm))
  type_next_chunk()
end

function M.stop()
  if not state.is_running then
    return
  end

  state.is_running = false
  state.is_paused = false

  state.timer = nil

  -- Remove the 'q' key mapping
  pcall(vim.keymap.del, 'n', 'q', { buffer = state.target_buffer })

  if config.preserve_original and state.target_buffer then
    local lines = vim.split(state.original_content[1], '\n', { plain = true })
    vim.api.nvim_buf_set_lines(state.target_buffer, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.target_buffer, 'modified', false)
  end

  print 'TimeLapse stopped'
end

function M.pause()
  if not state.is_running then
    print 'TimeLapse is not running'
    return
  end

  state.is_paused = not state.is_paused

  if state.is_paused then
    print 'TimeLapse paused'
  else
    print 'TimeLapse resumed'
    type_next_chunk()
  end
end

function M.set_wpm(wpm)
  if wpm and wpm > 0 then
    config.wpm = wpm
    print(string.format('TimeLapse WPM set to %d', config.wpm))
  else
    print(string.format('Current WPM: %d', config.wpm))
  end
end

function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend('force', config, opts)

  vim.api.nvim_create_user_command('TimeLapse', function(args)
    if args.args and args.args ~= '' then
      local wpm = tonumber(args.args)
      if wpm then
        M.set_wpm(wpm)
      end
    end
    M.start()
  end, {
    nargs = '?',
    desc = 'Start typing time-lapse animation. Optional: specify WPM',
  })

  vim.api.nvim_create_user_command('TimeLapsePause', M.pause, {
    desc = 'Pause/resume the typing time-lapse animation',
  })
end

return M

