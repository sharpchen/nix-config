/**
 * @param {{prompt: string, action: () => void}} opts
 */
exports.confirm = function (opts) {
  mp.input.select({
    prompt: opts.prompt,
    items: ['no', 'yes'],
    submit: function (id) {
      if (id === 2) {
        opts.action()
      }
    },
  })
}
