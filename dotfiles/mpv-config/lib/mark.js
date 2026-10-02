var FS = require('fileSystem')

/**
 * @constructor
 */
function SingleMark() {
  this.pos = undefined
}

/**
 * @param {number} time
 */
SingleMark.prototype.push = function (time) {
  this.pos = time
  mp.set_property_native('chapter-list', [{ time: this.pos, title: 'single_mark' }])
}

SingleMark.prototype.clear = function () {
  this.pos = undefined
}

SingleMark.prototype.clip = function () {
  throw new Error('Not implemented')
}

/**
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
SingleMark.prototype.clipFromStart = function (inputPath, mode) {
  assertNonNull(this.pos, 'SingleMark.pos')
  require('ffmpeg').clip({
    mode: mode,
    start: 0,
    end: this.pos,
    inputPath: inputPath,
    outPath: FS.Path.filePathFromFormat(inputPath, {
      format: '{base}_{}',
      value: '{}_{}'.format(
        mp.format_time(0).replace(/:/g, '-'),
        mp.format_time(this.pos).replace(/:/g, '-')
      ),
    }),
  })
}

/**
 *
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
SingleMark.prototype.clipToEnd = function (inputPath, mode) {
  assertNonNull(this.pos, 'SingleMark.pos')
  var duration = mp.get_property_number('duration')
  assertNonNull(duration, 'duration')

  require('ffmpeg').clip({
    mode: mode,
    start: this.pos,
    end: duration,
    inputPath: inputPath,
    outPath: FS.Path.filePathFromFormat(inputPath, {
      format: '{base}_{}',
      value: '{}_{}'.format(
        mp.format_time(this.pos).replace(/:/g, '-'),
        mp.format_time(duration).replace(/:/g, '-')
      ),
    }),
  })
}

/**
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
SingleMark.prototype.clipRanges = function (inputPath, mode) {
  assertNonNull(this.pos, 'SingleMark.pos')
  var duration = mp.get_property_number('duration')
  assertNonNull(duration, 'duration')

  this.clipFromStart(inputPath, mode)

  this.clipToEnd(inputPath, mode)
}

/**
 * @constructor
 */
function DualMark() {
  /** @type { [number | undefined, number | undefined] } */
  this.pos = [undefined, undefined]
}

/**
 * @typedef {typeof DualMark} DualMarkClass
 */

/**
 * @param {number} time
 */
DualMark.prototype.push = function (time) {
  /** @type {mp.ChapterListItem[]} */
  var chapters = []

  this.pos.shift() // discard one old mark
  this.pos.push(time)

  // update chapter-list on every new mark
  if (this.pos[0] !== undefined && this.pos[1] !== undefined) {
    var start = Math.min(this.pos[0], this.pos[1])
    var end = Math.max(this.pos[0], this.pos[1])
    chapters.push({
      time: start,
      title: 'clip-start',
    })
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
  }

  mp.set_property_native('chapter-list', chapters)
}

DualMark.prototype.clear = function () {
  this.pos = [undefined, undefined]
}

/**
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
DualMark.prototype.clip = function (inputPath, mode) {
  if (this.pos[0] === undefined || this.pos[1] === undefined) {
    throw new Error('Invalid position: at least one of position from DualMark.pos is undefined.')
  }

  var start = Math.min(this.pos[0], this.pos[1])
  var end = Math.max(this.pos[0], this.pos[1])

  require('ffmpeg').clip({
    mode: mode,
    start: start,
    end: end,
    inputPath: inputPath,
    outPath: FS.Path.filePathFromFormat(inputPath, {
      format: '{base}_{}',
      value: '{}_{}'.format(
        mp.format_time(start).replace(/:/g, '-'),
        mp.format_time(end).replace(/:/g, '-')
      ),
    }),
  })
}

/**
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
DualMark.prototype.clipRanges = function (inputPath, mode) {
  var duration = mp.get_property_number('duration')
  assertNonNull(duration, 'duration')

  var clone = this.pos.concat()
  clone.unshift(0) // prepend time start 0
  clone.push(duration)

  for (var i = 0; i < clone.length - 1; i++) {
    assertNonNull(clone[i], 'DualMark.pos[{}]'.format(i))

    var start = clone[i]
    var end = clone[i + 1]
    assertNonNull(start, 'start')
    assertNonNull(end, 'end')

    require('ffmpeg').clip({
      mode: mode,
      start: start,
      end: end,
      inputPath: inputPath,
      outPath: FS.Path.filePathFromFormat(inputPath, {
        format: '{base}_{}',
        value: '{}_{}'.format(
          mp.format_time(start).replace(/:/g, '-'),
          mp.format_time(end).replace(/:/g, '-')
        ),
      }),
    })
  }
}

function MultipleMark() {
  /** @type number[] */
  this.pos = []
}

MultipleMark.prototype.clear = function () {
  this.pos = []
}

/**
 * @param {number} time
 */
MultipleMark.prototype.push = function (time) {
  this.pos.push(time)
  var chapter = []
  for (var i = 0; i < this.pos.length; i++) {
    chapter.push({ time: this.pos[i], title: 'multiple_mark: {}'.format(i) })
  }
  mp.set_property_native('chapter-list', chapter)
}
/**
 * @param {string} inputPath
 * @param {ffmpeg.ClipMode} mode
 */
MultipleMark.prototype.clipRanges = function (inputPath, mode) {
  var duration = mp.get_property_number('duration')
  assertNonNull(duration, 'duration')

  var clone = this.pos.concat()
  clone.unshift(0) // prepend time start 0
  clone.push(duration)

  for (var i = 0; i < clone.length - 1; i++) {
    assertNonNull(clone[i], 'MultipleMark.pos[{}]'.format(i))

    var start = clone[i]
    var end = clone[i + 1]
    assertNonNull(start, 'start')
    assertNonNull(end, 'end')

    require('ffmpeg').clip({
      mode: mode,
      start: start,
      end: end,
      inputPath: inputPath,
      outPath: FS.Path.filePathFromFormat(inputPath, {
        format: '{base}_{}',
        value: '{}_{}'.format(
          mp.format_time(start).replace(/:/g, '-'),
          mp.format_time(end).replace(/:/g, '-')
        ),
      }),
    })
  }
}

module.exports = {
  SingleMark: SingleMark,
  DualMark: DualMark,
  MultipleMark: MultipleMark,
}
