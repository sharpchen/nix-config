// No global variable, but a module's this at its top lexical scope is the global object - also in strict mode.
// If you have a module which needs global as the global object, you could do this.global = this; before require.

mp.module_paths.push(mp.utils.get_user_path('~~/lib'))

require('env')
require('extension')
require('globals')
