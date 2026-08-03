/**
 * @param {any} cond
 * @param {string | undefined} msg
 */
// @ts-ignore
this.assert = function (cond, msg) {
  msg = msg || 'Assertion Failed!'
  if (!cond) {
    throw new Error(msg)
  }
}

/**
 * @param {any} cond
 * @param {string | undefined} nameof
 */
// @ts-ignore
this.assertNonNull = function (cond, nameof) {
  var msg = (nameof ? nameof : 'Value') + ' is undefined or null!'
  if (cond === void 0 || cond === null) {
    throw new Error(msg)
  }
}

// @ts-ignore
this.Env = require('env')

/**
 * @param {string} path
 */
this.assertFile = function (path) {
  if (!require('fileSystem').File.exists(path)) {
    throw new Error('File does not exist: {}'.format(path))
  }
}

/**
 * @param {mp.LogLevel} loglevel
 * @param {string} msg
 */
this.logAndShow = function (loglevel, msg) {
  mp.msg.log(loglevel, msg)
  mp.osd_message(msg)
}

/**
 * @param {string} path
 */
this.assertPathValid = function (path) {
  var filename = require('fileSystem').Path.basename(path, { includeExtention: true })
  var dirname = require('fileSystem').Path.dirname(path)

  if (
    // @ts-ignore
    filename.indexOfAny(Env.InvalidFileNameChars) !== -1 ||
    // @ts-ignore
    dirname.indexOfAny(Env.InvalidPathChars) !== -1
  ) {
    throw new Error('Path invalid: {}'.format(path))
  }
}
