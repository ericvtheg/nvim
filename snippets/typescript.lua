local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- TypeScript expect error
  s('tse', {
    t '// @ts-expect-error ',
    i(1, 'reason'),
  }),

  -- TypeScript ignore next line
  s('tsi', {
    t '// @ts-ignore',
  }),

  -- TypeScript no-check
  s('tsnc', {
    t '// @ts-nocheck',
  }),

  -- ESLint disable next line
  s('esn', {
    t '// eslint-disable-next-line ',
    i(1, 'rule-name'),
  }),

  -- ESLint disable line
  s('esl', {
    t ' // eslint-disable-line ',
    i(1, 'rule-name'),
  }),

  -- ESLint disable
  s('esd', {
    t '/* eslint-disable */',
  }),

  -- ESLint enable
  s('ese', {
    t '/* eslint-enable */',
  }),

  -- ESLint disable specific rule
  s('esdr', {
    t '/* eslint-disable ',
    i(1, 'rule-name'),
    t ' */',
  }),
}

