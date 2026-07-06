var File = {}
var Directory = {}

/**
 * @param {string} path
 * @returns {boolean}
 */
File.exists = function (path) {
  var f = mp.utils.file_info(path)
  return !!f && f.is_file
}

/**
 * @param {string} filePath
 * @returns {string | undefined}
 */
File.getExtension = function (filePath) {
  var dot = filePath.lastIndexOf('.')
  return dot !== -1 ? filePath.substring(dot) : undefined
}

/**
 * @param {string} path
 * @returns {void}
 */
File.delete = function (path) {
  if (!File.exists(path)) {
    return
  }

  mp.command_native_async({
    name: 'subprocess',
    args: [Env.IsWindows ? 'del' : 'rm', path],
    playback_only: false,
    detach: true,
  })
}

/**
 * @param {string} path
 * @returns {void}
 */
File.trash = function (path) {
  if (!File.exists(path)) {
    return
  }

  if (Env.IsWindows) {
    // escape single quote for actual value of __path__ placeholder
    var escapedPath = path.replace("'", "''")
    var ps1 = [
      'Add-Type -AssemblyName Microsoft.VisualBasic',
      "[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('__path__', 'OnlyErrorDialogs', 'SendToRecycleBin')".replace(
        '__path__',
        escapedPath
      ),
    ].join('\n')

    mp.command_native_async({
      name: 'subprocess',
      args: ['powershell', '-nologo', '-noprofile', '-noninteractive', '-c', ps1],
      playback_only: false,
      detach: true,
    })
  } else {
    throw new Error('File.trash not implemented for this platform.')
  }
}

/**
 * @param {string} path
 * @returns {boolean}
 */
Directory.exists = function (path) {
  var f = mp.utils.file_info(path)
  return !!f && f.is_dir
}

/**
 * @param {string} path
 */
function assertFile(path) {
  if (!File.exists(path)) {
    throw new Error(path + ' does not exist.')
  }
}

/**
 * @param {string} filePath
 * @returns {string}
 */
function basename(filePath) {
  var splits = mp.utils.split_path(filePath)
  var filename = splits[1]

  if (filename === '') {
    // meaning this path is a directory
    // foo/bar/
    // note that directory separator is always / in mpv
    return (
      filePath
        .split('/')
        .filter(function (c) {
          return c !== ''
        })
        .pop() || filePath
    )
  } else {
    // path/to/foo.txt or foo.txt
    var dot = filename.lastIndexOf('.')
    return dot !== -1 ? filename.substring(0, dot) : filename
  }
}

/**
 * attempt to generate a new file path with number index based on given path
 * until the file path doesn't exist
 * @param {string} filePath
 * @param {{prefix?: string, suffix?: string, indexPad?: number }} opts
 * @returns {string}
 */
function newFilePathWithIndex(filePath, opts) {
  opts.prefix = opts.prefix || ''
  opts.suffix = opts.suffix || ''
  opts.indexPad = opts.indexPad || 0

  assertFile(filePath)

  var splits = mp.utils.split_path(filePath)
  var dirname = splits[0]
  var filename = splits[1]
  var ext = File.getExtension(filename) || ''
  var base = basename(filename)

  var idx = 0
  do {
    idx++
    var newBaseName = [
      opts.prefix,
      opts.prefix !== '' ? idx.toString().padLeft(opts.indexPad, '0') : '',
      base,
      opts.suffix,
      opts.suffix !== '' ? idx.toString().padLeft(opts.indexPad, '0') : '',
    ]
      .filter(function (p) {
        return p !== ''
      })
      .join('_') // prefix_idx_basename_suffix_idx

    var newName = newBaseName + ext
    var newPath = mp.utils.join_path(dirname, newName)
  } while (File.exists(newPath))

  return newPath
}

module.exports = {
  File: File,
  Directory: Directory,
  basename: basename,
  newFilePathWithIndex: newFilePathWithIndex,
}
