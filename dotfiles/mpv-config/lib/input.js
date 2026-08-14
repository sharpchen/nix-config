/**
 * @typedef {Object} confirmOpts
 * @property {string} prompt
 * @property {() => void} yes
 * @property {() => void} [no]
 */

/**
 * @param {confirmOpts} opts
 */
exports.confirm = function (opts) {
  mp.input.select({
    prompt: opts.prompt,
    items: ['no', 'yes'],
    submit: function (id) {
      if (id === 2) {
        opts.yes()
      } else {
        if (opts.no) opts.no()
      }
    },
  })
}
