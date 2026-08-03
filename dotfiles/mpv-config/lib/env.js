var platform = mp.get_property('platform')

var char1_to_31 = []
for (var i = 1; i <= 31; i++) {
  char1_to_31.push(String.fromCharCode(i))
}

module.exports = {
  // see: https://github.com/dotnet/dotnet/blob/b0f34d51fccc69fd334253924abd8d6853fad7aa/src/runtime/src/libraries/System.Private.CoreLib/src/System/IO/Path.Windows.cs#L15-L31
  InvalidFileNameChars:
    platform === 'windows'
      ? [':', '/', '\\', '*', '?', '"', '<', '>', '|', '\0'].concat(char1_to_31)
      : ['\0', '/'],
  InvalidPathChars: platform === 'windows' ? ['|', '\0'].concat(char1_to_31) : ['\0'],
  IsWindows: platform === 'windows',
  IsLinux: platform === 'linux',
  IsDarwin: platform === 'darwin',
  IsAndroid: platform === 'android',
  IsFreeBSD: platform === 'freebsd',
}
