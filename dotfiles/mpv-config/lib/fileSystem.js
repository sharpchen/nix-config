var File = {}
var Directory = {}
var Path = {}

exports.File = File
exports.Directory = Directory
exports.Path = Path

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
 * @returns {string} undefined if not found
 */
Path.extension = function (filePath) {
  var dot = filePath.lastIndexOf('.')
  return dot !== -1 ? filePath.substring(dot) : ''
}

Path.getTempPath = function () {
  switch (mp.get_property('platform')) {
    case 'windows':
      var tmp = mp.utils.getenv('TEMP')
      if (tmp && !tmp.isNullOrEmpty()) return tmp
      tmp = mp.utils.getenv('TMP')
      if (tmp && !tmp.isNullOrEmpty()) return tmp
      throw new Error('Temp path not found on Windows.')
    default:
      var tmp = mp.utils.getenv('TMPDIR')
      if (tmp && !tmp.isNullOrEmpty()) return tmp
      return '/tmp/'
  }
}

/**
 * @returns {string}
 */
Path.getTempFilePath = function () {
  var prefix = 'mpv-'
  var ext = '.tmp'
  var tempBase = Path.getTempPath()
  var path
  // NOTE: this is not thread safe as it doesn't lock the file on trying
  // but we have a prefix here makes it very unlikely
  do {
    path = mp.utils.join_path(
      tempBase,
      prefix + Math.floor(Math.random() * 0xffffff).toString(16) + ext
    )
  } while (File.exists(path))

  return mp.command_native({
    name: 'normalize-path',
    filename: path,
  })
}

/**
 * @param {...string} args
 * @returns {string}
 */
Path.join = function () {
  // NOTE: args is actually IArguments here
  var path = arguments[0]
  var nextIdx = 1

  while (nextIdx < arguments.length) {
    path = mp.utils.join_path(path, arguments[nextIdx])
    nextIdx++
  }

  return path || ''
}

/**
 * @param {string} path
 * @returns {void}
 */
File.deleteAsync = function (path) {
  if (!File.exists(path)) {
    return
  }

  mp.command_native_async({
    name: 'subprocess',
    args: Env.IsWindows ? ['cmd', '/c', 'del', path] : ['rm', path],
    playback_only: false,
    detach: true,
  })
}

/**
 * @param {string} path
 * @returns {void}
 */
File.trashAsync = function (path) {
  if (!File.exists(path)) {
    return
  }

  if (Env.IsWindows) {
    // escape single quote for actual value of __path__ placeholder
    var escapedPath = path.replace(/'/g, "''")
    var ps1 = [
      'Add-Type -AssemblyName Microsoft.VisualBasic',
      "[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('{}', 'OnlyErrorDialogs', 'SendToRecycleBin')".format(
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
 * @param {{includeExtention?: boolean}} [opts]
 * @returns {string} Last component of the path, doesn't inlcude extension
 * if {path} is a file and {opts.includeExtention} is false(default)
 */
Path.basename = function (path, opts) {
  opts = opts || {}
  opts.includeExtention = opts.includeExtention !== undefined ? opts.includeExtention : false
  var splits = mp.utils.split_path(path)
  var filename = splits[1]

  if (filename === '') {
    // meaning this path is a directory
    // foo/bar/
    // note that directory separator is always / in mpv
    return (
      path
        .split('/')
        .filter(function (c) {
          return c !== ''
        })
        .pop() || path
    )
  } else {
    // path/to/foo.txt or foo.txt
    if (!opts.includeExtention) {
      var dot = filename.lastIndexOf('.')
      return dot !== -1 ? filename.substring(0, dot) : filename
    } else {
      return filename
    }
  }
}

/**
 * Generate a new file path from basename of the file(no extension), with value interpolated
 * For `opts.format`, use `{base}` for basename of the path, `{}` for opts.value
 * NOTE: only one value can be interpolated, so only one `{}` is allowed
 * @param {string} path
 * @param {{format: string, value: string}} opts
 * @returns {string}
 * @example
 * ```js
   // returns foo/bar/file-part001.mp4
   filePathFromFormat('foo/bar/file.mp4', {
      format: '{base}-part{}',
      value: "001"
   })
 * ```
 */
Path.filePathFromFormat = function (path, opts) {
  assert(!path.includes('{base}'), '{{path}} should not contain "{{base}}": {}'.format(path))
  assert(!path.endsWith('/'), '{{path}} is not a file: {}'.format(path))
  var basename = Path.basename(path)
  var dirname = Path.dirname(path)
  var extension = Path.extension(path) || ''
  return (
    opts.format.replace('{base}', mp.utils.join_path(dirname, basename)).format(opts.value) +
    extension
  )
}

/**
 * @param {string} path
 * @returns {string}
 */
Path.dirname = function (path) {
  return mp.utils.split_path(path)[0]
}

/**
 * attempt to generate a new file path with number index based on given path
 * until the file path doesn't exist
 * @example
 * ```js
 * // returns foo/bar/file-part001.mp4 etc.
 * tryFilePathWithIndex('foo/bar/file.mp4', {
 *      format: '{{}}-part{}',
 *      indexPad: 3,
 * })
 * ```
 * @param {string} filePath
 * @param {{ format: string, indexPad?: number }} opts
 * @returns {string}
 */
Path.tryFilePathWithIndex = function (filePath, opts) {
  opts.indexPad = opts.indexPad || 0

  assertFile(filePath)

  var idx = 0
  do {
    idx++
    var newPath = Path.filePathFromFormat(filePath, {
      format: opts.format,
      value: idx.toString().padLeft(opts.indexPad, '0'),
    })
  } while (File.exists(newPath))

  return newPath
}
