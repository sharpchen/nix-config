var ff_cmd = ['ffmpeg', '-loglevel', 'error', '-hide_banner']
var ff_conat_cmd = ff_cmd.concat(['-safe', '0'])
var FS = require('fileSystem')

/**
 * @typedef {Object} confirmOpts
 * @property {string} okMessageFormat
 * @property {string[]} cmd
 * @property {() => void} [finally] action to possibly dispose resource after command execution
 */

/**
 * @param {string} outPath
 * @param {confirmOpts} opts
 */
function confirmOverwrite(outPath, opts) {
  /**
   *
   * @param {string} output
   * @param {string[]} command
   */
  function apply(output, command) {
    mp.command_native_async(
      {
        name: 'subprocess',
        args: command,
        capture_stderr: true,
      },
      function (ok, out, _) {
        if (ok && out.status === 0) {
          var msg = '[ffmpeg] {}'.format(opts.okMessageFormat).format(output)
          logAndShow('info', msg)
        } else {
          logAndShow('error', out.stderr)
        }
        if (opts.finally) opts.finally()
      }
    )
  }
  if (FS.File.exists(outPath)) {
    mp.input.select({
      prompt: '[ffmpeg] output file already exists: {}'.format(outPath),
      items: ['abort', 'override'],
      submit: function (id) {
        if (id === 2) {
          opts.cmd.splice(1, 0, '-y')
          apply(outPath, opts.cmd)
        }
      },
    })
  } else {
    apply(outPath, opts.cmd)
  }
}

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
  confirmOverwrite(opts.outPath, {
    okMessageFormat: 'clip created: {}',
    cmd: ff_cmd.concat([
      '-i',
      opts.inputPath,
      '-c',
      'copy',
      '-ss',
      opts.start.toString(),
      '-to',
      opts.end.toString(),
      opts.outPath,
    ]),
  })
}

/**
 * @typedef {Object} SetChapterOpts
 * @property {mpv.Chapter[]} chapters
 * @property {string} inputPath
 * @property {string} outPath
 * @property {number} duration
 * @property {string} lastChapterName
 */

/**
 * @param {SetChapterOpts} opts
 */
exports.writeChapters = function (opts) {
  assertFile(opts.inputPath)
  assertPathValid(opts.outPath)

  // has to type the seed first otherwise literal [] is inferred as never[] at the arr.reduce callsite
  /** @type {string[]} */
  var lines = [';FFMETADATA1'] // first line contains an instruction for ffmpeg

  var chapters = opts.chapters.concat()
  // title doesn't matter for the two inserted as they are not end of chapter anyway
  chapters.unshift({ time: 0, title: 'start' })
  chapters.push({ time: opts.duration, title: 'end' })

  for (var i = 0; i < chapters.length - 1; i++) {
    lines.push('[CHAPTER]')
    lines.push('TIMEBASE=1/1000')
    lines.push('START={}'.format(Math.round(chapters[i].time * 1000)))
    lines.push('END={}'.format(Math.round(chapters[i + 1].time * 1000)))
    // the title should be given when you mark the end of chapter
    lines.push(
      'title={}'.format(
        i === chapters.length - 1 - 1 ? opts.lastChapterName : chapters[i + 1].title
      )
    )
  }

  var temp = FS.Path.getTempFilePath()

  mp.utils.write_file('file://{}'.format(temp), lines.join('\n'))

  confirmOverwrite(opts.outPath, {
    okMessageFormat: 'chapters written to {}',
    cmd: ff_cmd.concat([
      '-i',
      opts.inputPath,
      '-i',
      temp,
      '-map_metadata',
      '1',
      '-c',
      'copy',
      opts.outPath,
    ]),
    finally: function () {
      FS.File.deleteAsync(temp)
    },
  })
}
