var platform = mp.get_property('platform')

module.exports = {
  IsWindows: platform === 'windows',
  IsLinux: platform === 'linux',
  IsDarwin: platform === 'darwin',
  IsAndroid: platform === 'android',
  IsFreeBSD: platform === 'freebsd',
}
