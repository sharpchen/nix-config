/**
 * @param {number} width
 * @param {string} padChar
 * @returns {string}
 */
String.prototype.padLeft = function (width, padChar) {
  var s = this.valueOf()
  padChar = padChar || ' '
  // assert(width >= 0, "width must be ge 0");
  // assert(padChar.length == 1, "padchar must be single char");
  var count = width - s.length
  return count <= 0 ? this.valueOf() : padChar.repeat(count) + s
}

/**
 * @param {number} width
 * @param {string} padChar
 * @returns {string}
 */
String.prototype.padRight = function (width, padChar) {
  var s = this.valueOf()
  padChar = padChar || ' '
  // assert(width >= 0, "width must be ge 0");
  // assert(padChar.length == 1, "padchar must be single char");
  var count = width - s.length
  return count <= 0 ? this.valueOf() : s + padChar.repeat(count)
}

/**
 * @param {number} count
 * @returns {string}
 */
String.prototype.repeat = function (count) {
  var s = this.valueOf()
  var ret = ''
  for (var i = 0; i < count; i++) {
    ret += s
  }
  return ret
}
