/**
 * @typedef {Object} CycleOpts
 * @property {string} qualifiedName <script_name>-<option_name>
 * @property {() => string} current a function returns current value of the option
 * @property {string[]} values list of candidates
 */

/**
 * Cycle values for an entry of `script-opts`
 * For regular properties, use `cycle-values` command
 * @async
 * @param {CycleOpts} opts
 */
exports.cycle = function (opts) {
  var current = opts.current()
  var currentIdx = opts.values.indexOf(current)

  if (currentIdx === -1) {
    throw new Error('opts.values contains no candidate equals `{}`'.format(current))
  }

  var next = currentIdx === opts.values.length - 1 ? opts.values[0] : opts.values[currentIdx + 1]

  // NOTE: script-opts is a list option, use change-list to manipulate its elements(opts)
  mp.commandv('change-list', 'script-opts', 'append', '{}={}'.format(opts.qualifiedName, next))
}
