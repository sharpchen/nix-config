mp.module_paths.push(mp.utils.get_user_path('~~/lib'))

require('env')
require('extension')
require('globals')

var errorLayer = mp.create_osd_overlay('ass-events')

mp.enable_messages('fatal')

/** @type {__TimeoutId} */
var timeout
// show error on osd immediately
mp.register_event('log-message', function (e) {
  // TODO: show multiple errors as message queue
  // FIXME: however same error can be reported multiple times(from different "prefix")
  // likely a mpv internal problem, this should be addressed first
  if (e.level === 'fatal' && e.text.includes('Error: ')) {
    // see: https://aegisub.org/docs/latest/ass_tags/#\c
    var msg = '{{\\c&H0000FF>&}}[{}] {}'.format(e.prefix, e.text)
    errorLayer.data = msg
    errorLayer.update()

    // if new error comes, cancel the previous timeout
    if (timeout !== undefined) {
      clearTimeout(timeout)
    }
    // start counting again
    timeout = setTimeout(function () {
      errorLayer.remove()
    }, 5000)
  }
})
