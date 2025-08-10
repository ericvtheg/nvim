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

local function type_character()
  if not state.is_running or state.is_paused then
    return
  end
  
  local text = table.concat(state.original_content, '')
  
  if state.current_pos > #text then
    M.stop()
    return
  end
  
  local current_text = string.sub(text, 1, state.current_pos)
  local lines = vim.split(current_text, '\n', { plain = true })
  
  vim.api.nvim_buf_set_lines(state.target_buffer, 0, -1, false, lines)
  
  local last_line = #lines
  local last_col = #lines[last_line]
  vim.api.nvim_win_set_cursor(0, { last_line, last_col })
  
  vim.cmd('redraw')
  
  state.current_pos = state.current_pos + 1
  
  state.timer = vim.defer_fn(type_character, calculate_delay_ms(config.wpm))
end

function M.start()
  if state.is_running then
    print("TimeLapse is already running")
    return
  end
  
  state.target_buffer = vim.api.nvim_get_current_buf()
  local text = get_buffer_text()
  
  if text == "" then
    print("Buffer is empty")
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
  
  print(string.format("Starting TimeLapse at %d WPM", config.wpm))
  type_character()
end

function M.stop()
  if not state.is_running then
    return
  end
  
  state.is_running = false
  state.is_paused = false
  
  if state.timer then
    pcall(vim.fn.timer_stop, state.timer)
    state.timer = nil
  end
  
  if config.preserve_original and state.target_buffer then
    local lines = vim.split(state.original_content[1], '\n', { plain = true })
    vim.api.nvim_buf_set_lines(state.target_buffer, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.target_buffer, 'modified', false)
  end
  
  print("TimeLapse stopped")
end

function M.pause()
  if not state.is_running then
    print("TimeLapse is not running")
    return
  end
  
  state.is_paused = not state.is_paused
  
  if state.is_paused then
    print("TimeLapse paused")
  else
    print("TimeLapse resumed")
    type_character()
  end
end

function M.set_wpm(wpm)
  if wpm and wpm > 0 then
    config.wpm = wpm
    print(string.format("TimeLapse WPM set to %d", config.wpm))
  else
    print(string.format("Current WPM: %d", config.wpm))
  end
end

function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_deep_extend('force', config, opts)
  
  vim.api.nvim_create_user_command('TimeLapse', function(args)
    if args.args and args.args ~= "" then
      local wpm = tonumber(args.args)
      if wpm then
        M.set_wpm(wpm)
      end
    end
    M.start()
  end, { 
    nargs = '?',
    desc = 'Start typing time-lapse animation. Optional: specify WPM'
  })
  
  vim.api.nvim_create_user_command('TimeLapseStop', M.stop, {
    desc = 'Stop the typing time-lapse animation'
  })
  
  vim.api.nvim_create_user_command('TimeLapsePause', M.pause, {
    desc = 'Pause/resume the typing time-lapse animation'
  })
  
end

return M