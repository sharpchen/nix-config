var ff_cmd = ['ffmpeg', '-loglevel', 'error', '-hide_banner']
var ff_conat_cmd = ff_cmd.concat(['-safe', '0'])
var FS = require('fileSystem')

/**
 * @typedef {Object} ClipOpts
 * @property {number} start
 * @property {number} end
 * @property {string} inputPath
 * @property {string} outPath
 */

/**
 * @param {ClipOpts} opts
 */
exports.clip = function (opts) {
  assertFile(opts.inputPath)
  assertPathValid(opts.outPath)
  if (FS.File.exists(opts.outPath)) {
    mp.input.select({
      prompt: '[ffmpeg] output file already exists: {}'.format(opts.outPath),
      items: ['abort', 'override'],
      submit: function (id) {
        if (id === 2) {
          _clip({ force: true })
        }
      },
    })
  } else {
    _clip({ force: false })
  }

  /**
   * @param {{force: boolean}} o
   */
  function _clip(o) {
    var cmd = ff_cmd.concat([
      '-i',
      opts.inputPath,
      '-c',
      'copy',
      '-ss',
      opts.start.toString(),
      '-to',
      opts.end.toString(),
      opts.outPath,
    ])

    if (o.force) {
      cmd.splice(1, 0, '-y')
    }

    mp.command_native_async(
      {
        name: 'subprocess',
        args: cmd,
        capture_stderr: true,
      },
      function (ok, out, _) {
        if (ok && out.status === 0) {
          var msg = '[ffmpeg] clip created: {}'.format(opts.outPath)
          logAndShow('info', msg)
        } else {
          logAndShow('error', out.stderr)
        }
      }
    )
  }
}
