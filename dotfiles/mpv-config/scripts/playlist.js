var FS = require('fileSystem')

function removeCurrentEntry() {
  var count = mp.get_property_number('playlist-count')
  assertNonNull(count, 'count is undefined')
  var current = mp.get_property_number('playlist-pos')
  assertNonNull(current, 'current is undefined')

  // if current is the last one, move to previous entry
  // if not, move to next entry
  var newPos = current === count - 1 ? current - 1 : current + 1

  // the newPos can be -1 if current is the only entry in the playlist
  // setting to -1 sets the player idle or exit
  // see: https://mpv.io/manual/stable/#command-interface-playlist-pos
  mp.set_property_number('playlist-pos', newPos)

  if (newPos > -1) {
    mp.commandv('playlist-remove', current.toString())
  }
}

mp.add_key_binding('del', 'playlist-trash-current', function () {
  var currentPath = mp.get_property('path') // order matters here
  assertNonNull(currentPath, 'currentPath')
  removeCurrentEntry()
  FS.File.trash(currentPath)
})
