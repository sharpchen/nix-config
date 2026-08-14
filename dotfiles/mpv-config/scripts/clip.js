/**
 * @typedef {Object} ScriptOpts
 * @property { 'dual' | 'single' | 'multiple' } mode
 */

/**
 * @type {ScriptOpts}
 */
var _opts = {
  mode: 'dual',
}

var m = require('mark')
var _dual = new m.DualMark()
var _single = new m.SingleMark()
var _multiple = new m.MultipleMark()

/**
 * @type { import('../lib/mark.js').DualMark | import('../lib/mark.js').SingleMark | import('../lib/mark.js').MultipleMark }
 */
var _mark = _dual

mp.options.read_options(_opts, undefined, function (changed) {
  if (changed.mode) {
    mp.osd_message('{}-mode: {}'.format(mp.get_script_name(), _opts.mode), 5)

    switch (_opts.mode) {
      case 'dual':
        _mark = _dual
        break
      case 'single':
        _mark = _single
        break
      case 'multiple':
        _mark = _multiple
        break
    }
  }
})

mp.add_key_binding('t-m', 'toggle-mark-mode', function () {
  // NOTE: `change-list` used in this function is asynchronous
  // so the operation on toggle should be set on callback of `read_options`
  require('option').cycle({
    qualifiedName: '{}-mode'.format(mp.get_script_name()),
    current: function () {
      return _opts.mode
    },
    values: ['dual', 'single', 'multiple'],
  })
})

mp.add_key_binding('M', 'clip-mark-set', function () {
  // pin osc layer so we can see marks as we set
  mp.commandv('change-list', 'script-opts', 'append', 'osc-visibility=always')
  var time = mp.get_property_number('time-pos')
  assertNonNull(time)
  _mark.push(time)
})

mp.add_key_binding('d-m', 'clip-mark-clear', function () {
  require('input').confirm({
    prompt: 'Are you sure to clear marks?',
    yes: function () {
      _mark.clear()
      mp.set_property_native('chapter-list', [])
      mp.commandv('change-list', 'script-opts', 'append', 'osc-visibility=auto')
    },
  })
})

mp.add_key_binding('C-C', 'clip-mark-apply', function () {
  var inputPath = mp.get_property('path')
  assertNonNull(inputPath, 'inputPath')
  switch (_opts.mode) {
    case 'dual':
      // prompt output name
      mp.input.select({
        prompt: 'How to clip?',
        items: ['clamp', 'splits'],
        submit: function (id) {
          switch (id) {
            case 1:
              // @ts-ignore
              _mark.clip(inputPath)
              break
            case 2:
              // @ts-ignore
              _mark.clipRanges(inputPath)
              break
          }
        },
      })
      break
    case 'single':
      mp.input.select({
        prompt: 'How to clip?',
        items: ['from_start', 'to_end', 'splits'],
        submit: function (id) {
          switch (id) {
            case 1:
              // @ts-ignore
              _mark.clipFromStart(inputPath)
              break
            case 2:
              // @ts-ignore
              _mark.clipToEnd(inputPath)
              break
            case 3:
              // @ts-ignore
              _mark.clipRanges(inputPath)
              break
          }
        },
      })
      break
    case 'multiple':
      require('input').confirm({
        prompt: 'Clip marks into splits?',
        yes: function () {
          // @ts-ignore
          _mark.clipRanges(inputPath)
        },
      })
      break
  }
})
