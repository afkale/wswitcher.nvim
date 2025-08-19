local WSwitcher = {}
local H = {}

WSwitcher.config = {
  replace = false,
  keymap = '<C-s>',
  switches = {
    -- Boolean values
    True = 'False',
    False = 'True',
    ['true'] = 'false',
    ['false'] = 'true',
    TRUE = 'FALSE',
    FALSE = 'TRUE',

    -- Variable declarations
    ['const'] = 'let',
    ['let'] = 'const',
    ['var'] = 'let',

    -- Responses/answers
    ['yes'] = 'no',
    ['no'] = 'yes',
    ['on'] = 'off',
    ['off'] = 'on',

    -- Directions/positions
    ['left'] = 'right',
    ['right'] = 'left',
    ['up'] = 'down',
    ['down'] = 'up',
    ['top'] = 'bottom',
    ['bottom'] = 'top',
    ['first'] = 'last',
    ['last'] = 'first',

    -- Size/dimensions
    ['width'] = 'height',
    ['height'] = 'width',
    ['min'] = 'max',
    ['max'] = 'min',
    ['small'] = 'large',
    ['large'] = 'small',
    ['big'] = 'small',

    -- Visibility/display
    ['show'] = 'hide',
    ['hide'] = 'show',
    ['visible'] = 'hidden',
    ['hidden'] = 'visible',
    ['block'] = 'none',
    ['none'] = 'block',

    -- Actions
    ['push'] = 'pop',
    ['pop'] = 'push',
    ['add'] = 'remove',
    ['remove'] = 'add',
    ['insert'] = 'delete',
    ['delete'] = 'insert',
    ['create'] = 'destroy',
    ['destroy'] = 'create',
    ['open'] = 'close',
    ['close'] = 'open',
    ['enable'] = 'disable',
    ['disable'] = 'enable',
    ['start'] = 'stop',
    ['stop'] = 'start',
    ['play'] = 'pause',
    ['pause'] = 'play',

    -- HTTP methods
    ['GET'] = 'POST',
    ['POST'] = 'PUT',
    ['PUT'] = 'DELETE',
    ['DELETE'] = 'GET',

    -- Programming concepts
    ['public'] = 'private',
    ['private'] = 'public',
    ['sync'] = 'async',
    ['async'] = 'sync',
    ['import'] = 'export',
    ['export'] = 'import',

    -- Time-related
    ['before'] = 'after',
    ['after'] = 'before',
    ['old'] = 'new',
    ['new'] = 'old',
    ['previous'] = 'next',
    ['next'] = 'previous',
    ['past'] = 'future',
    ['future'] = 'past',

    -- State
    ['active'] = 'inactive',
    ['inactive'] = 'active',
    ['enabled'] = 'disabled',
    ['disabled'] = 'enabled',
    ['online'] = 'offline',
    ['offline'] = 'online',

    -- Text formatting
    ['normal'] = 'bold',
    ['bold'] = 'italic',
    ['italic'] = 'normal',
    ['uppercase'] = 'lowercase',
    ['lowercase'] = 'uppercase',
  }
}

H.default_config = vim.deepcopy(WSwitcher.config)

WSwitcher.setup = function(opts)
  _G.WSwitcher = WSwitcher

  opts = H.setup_config(opts)
  H.apply_config(opts)
  H.setup_keybinds()
end

H.setup_config = function(config)
  H.check_type('config', config, 'table', true)
  config = config or {}

  H.do_replace(config)
  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})

  H.check_type('config.replace', config.replace, 'boolean', true)
  H.check_type('config.keymap', config.keymap, 'string', true)
  H.check_type('config.switches', config.switches, 'table', true)

  return config
end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == 'callable' and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format('`%s` should be %s, not %s', name, ref, type(val)))
end

H.do_replace = function(config)
  if config == nil then return end

  if config.replace == true then
    H.default_config.switches = {}
  else
    H.default_config.switches = vim.deepcopy(WSwitcher.config.switches)
  end
end

H.apply_config = function(config) WSwitcher.config = config end

WSwitcher.switch = function()
  local word = vim.fn.expand('<cword>')
  local substitution = WSwitcher.config.switches[word]

  if substitution ~= nil then
    vim.api.nvim_feedkeys('*#cw' .. substitution, 'n', false)
    vim.api.nvim_input('<ESC>')
  elseif word ~= '' then
    vim.notify("No substitution found for '" .. word .. "'", vim.log.levels.WARN)
  end
end

H.setup_keybinds = function()
  vim.keymap.set("n", WSwitcher.config.keymap, WSwitcher.switch, {})
end

return WSwitcher
