/**
 * @param {number} width
 * @param {string} padChar
 * @returns {string}
 */
String.prototype.padLeft = function (width, padChar) {
  var s = this.valueOf()
  padChar = padChar || ' '
  assert(width >= 0, '{width} must be greater than 0')
  assert(padChar.length == 1, '{padChar} must be single char')
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
  assert(width >= 0, '{width} must be greater than 0')
  assert(padChar.length == 1, '{padChar} must be single char')
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

/**
 * "I am {}".format("john")
 * "I am {}, aged {}".format("john", 18)
 * "{{}}".format() => {}
 * @returns {string}
 */
String.prototype.format = function () {
  var argIdx = 0
  var pos = 0
  var charNextToBrace
  var builder = []

  outer: while (true) {
    // inner loop handles escaped braces and bad format of closing brace
    // and leave opening brace to outer loop
    while (true) {
      if (pos >= this.length) {
        break outer
      }

      var remainder = this.substring(pos)
      var nextBrace = remainder.indexOfAny(['{', '}'])

      if (nextBrace === -1) {
        builder.push(remainder) // no brace any more, done
        break outer
      }

      builder.push(remainder.substring(0, nextBrace))
      pos += nextBrace

      var brace = this.charAt(pos)
      charNextToBrace = this.charAt(++pos) // char next to the brace

      if (charNextToBrace === brace) {
        // if next char is { or } which is an escape, we should include the unescaped
        builder.push(charNextToBrace)
        pos++
        continue
      }

      // if it's closing but next char is not an escape
      if (brace === '}') {
        throw new Error('Bad format: unexpected closing brace.')
      }

      break // now it's an opening brace, leave it to outer loop
    }

    assert(this.charAt(pos - 1) === '{')
    assert(charNextToBrace !== '{') // should be unescaped already

    // char is already read in inner loop
    if (charNextToBrace !== '}') {
      throw new Error('Bad format: unexpected content inside slot.')
    } else {
      if (argIdx <= arguments.length - 1) {
        var arg = arguments[argIdx++]
        builder.push(arg)
        pos++
      } else {
        throw new Error('Argument error: no enough arguments.')
      }
    }
  }

  return builder.join('')
}

/**
 * @param {string[]} chars
 * @returns {number}
 */
String.prototype.indexOfAny = function (chars) {
  for (var i = 0; i < this.length; i++) {
    for (var j = 0; j < chars.length; j++) {
      if (chars[j].length !== 1) {
        throw new Error('Invalid argument: search string must be effectively a single char.')
      }
      if (this.charAt(i) === chars[j]) {
        return i
      }
    }
  }
  return -1
}

/**
 * @param {string} prefix
 */
String.prototype.startsWith = function (prefix) {
  return this.slice(0, prefix.length) === prefix
}

/**
 * @param {string} suffix
 */
String.prototype.endsWith = function (suffix) {
  return this.slice(-suffix.length) === suffix
}

/**
 * @param {string} str
 * @returns {boolean}
 */
String.prototype.includes = function (str) {
  return this.indexOf(str) !== -1
}

/**
 * @param {any[]} items
 * @returns {number}
 */
Array.prototype.indexOfAny = function (items) {
  for (var i = 0; i < this.length; i++) {
    for (var j = 0; j < items.length; j++) {
      if (this[i] === items[j]) {
        return i
      }
    }
  }
  return -1
}

/**
 * @param {any} item
 * @returns {boolean}
 */
Array.prototype.includes = function (item) {
  return this.indexOf(item) !== -1
}
