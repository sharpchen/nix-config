var FS = require('fileSystem')

/**
 * @type {mpv.Chapter[]}
 */
var _chapters = []

mp.add_key_binding('C-M', 'chapter-mark', function () {
  mp.input.get({
    prompt: 'name this chapter: ',
    submit: function (value) {
      if (value.isNullOrEmpty()) {
        logAndShow('error', 'chapter name is empty!')
        return
      }
      var time = mp.get_property_number('time-pos')
      assertNonNull(time, 'time')
      _chapters.push({ time: time, title: value })
      mp.set_property_native('chapter-list', _chapters)
      mp.commandv('change-list', 'script-opts', 'append', 'osc-visibility=always')
    },
  })
})

mp.add_key_binding('C-W', 'chapter-write-file', function () {
  mp.input.get({
    // because you can't name it on mark when using end as the node
    prompt: 'name the last chapter: ',
    submit: function (value) {
      if (value.isNullOrEmpty()) {
        logAndShow('error', 'chapter name is empty!')
        return
      }
      var inputPath = mp.get_property('path')
      var duration = mp.get_property_number('duration')
      assertNonNull(inputPath, 'path')
      assertNonNull(duration, 'duration')

      require('ffmpeg').writeChapters({
        inputPath: inputPath,
        outPath: FS.Path.filePathFromFormat(inputPath, {
          format: '{base}-with_chapter',
          value: '',
        }),
        duration: duration,
        lastChapterName: value,
        chapters: _chapters,
      })
    },
  })
})

mp.add_key_binding('d-C', 'chapter-clear', function () {
  require('input').confirm({
    prompt: 'Are you sure to clear chapters?',
    yes: function () {
      _chapters.length = 0 // clear it
      mp.set_property_native('chapter-list', [])
      mp.commandv('change-list', 'script-opts', 'append', 'osc-visibility=auto')
    },
  })
})
