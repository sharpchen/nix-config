/**
 * @typedef {Object} Chapter
 * @property {string} title
 * @property {number} time
 */

var FS = require('fileSystem')

/** @type { [number | undefined, number | undefined] } */
var timeMarks = [undefined, undefined]

function markCurrent() {
  var time = mp.get_property_number('time-pos')

  if (!time) {
    mp.osd_message('No valid time-pos captured.', 5)
    return
  }

  /** @type {Chapter[]} */
  var chapters = []

  timeMarks.shift() // discard one old mark
  timeMarks.push(time)

  // update chapter-list on every new mark
  if (timeMarks[0] !== void 0 && timeMarks[1] !== void 0) {
    var start = Math.min(timeMarks[0], timeMarks[1])
    var end = Math.max(timeMarks[0], timeMarks[1])

    mp.osd_message('clip-start: ' + start, 5)
    chapters.push({
      time: start,
      title: 'clip-start',
    })

    mp.osd_message('clip-end: ' + end, 5)
    chapters.push({
      time: end,
      title: 'clip-end',
    })
  } else {
    // if only the new mark is valid
    chapters.push({
      time: time,
      title: 'clip-start',
    })

    mp.osd_message('clip-start: ' + time, 5)
  }

  mp.set_property_native('chapter-list', chapters)
}

function markClear() {
  timeMarks = [undefined, undefined]
  mp.set_property_native('chapter-list', [])
}

function clipFromMarks() {
  if (timeMarks[0] === void 0 || timeMarks[1] === void 0) {
    mp.osd_message('You need two valid time marks to create a clip!', 5)
    return
  }

  var start = Math.min(timeMarks[0], timeMarks[1])
  var end = Math.max(timeMarks[0], timeMarks[1])

  if (end - start < 0.1) {
    mp.osd_message('Interval too short, aborting.', 5)
    return
  }

  var inputPath = mp.get_property('path')
  if (inputPath && FS.File.exists(inputPath)) {
    var outPath = FS.newFilePathWithIndex(inputPath, {
      prefix: 'clip',
      indexPad: 3,
    })

    mp.command_native_async(
      {
        name: 'subprocess',
        args: [
          'ffmpeg',
          '-i',
          inputPath,
          '-c',
          'copy',
          '-ss',
          start.toString(),
          '-to',
          end.toString(),
          outPath,
        ],
        capture_stderr: true,
      },
      function (ok, out, err) {
        // @ts-ignore
        if (ok && out.status === 0) {
          mp.osd_message('Created: ' + outPath, 5)
        } else {
          mp.osd_message('Creation FAILED: ' + outPath, 5)
          mp.msg.error(err)
        }
      }
    )
  } else {
    mp.osd_message('Failed to get current file path', 5)
  }
}

mp.add_key_binding('M', 'clip-mark-set', markCurrent)

mp.add_key_binding(undefined, 'clip-mark-clear', function () {
  markClear()
})

mp.add_key_binding('C', 'clip-create', function () {
  clipFromMarks()
})
