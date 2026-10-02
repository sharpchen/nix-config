mp.add_key_binding('R-R', 'rotation-apply', function () {
  require('input').confirm({
    prompt: 'Apply current rotation?',
    yes: function () {
      var rotation = mp.get_property_number('video-rotate', 0)

      if (rotation !== 0) {
        // ffmpeg requires counter-clockwise rotation degree while video-rotate is clockwise
        // convert it to counter-clockwise
        var degree = (360 - rotation) % 360
        var path = mp.get_property('path')
        assertNonNull(path)
        require('ffmpeg').rotate({
          degree: degree,
          inputPath: path,
          outPath: require('fileSystem').Path.filePathFromFormat(path, {
            format: '{base}_{}',
            value: 'rotated_{}'.format(rotation),
          }),
        })
      }
    },
  })
})
