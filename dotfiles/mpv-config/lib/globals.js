/**
 * @param {any} cond
 * @param {string | undefined} msg
 */
// @ts-ignore
this.assert = function (cond, msg) {
  msg = msg || 'Assertion Failed!'
  if (!cond) {
    mp.msg.error(msg)
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
    mp.msg.error(msg)
    throw new Error(msg)
  }
}

// @ts-ignore
this.Env = require('env')
