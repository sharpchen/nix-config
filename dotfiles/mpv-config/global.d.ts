interface String {
  padLeft(width: number, padChar?: string): string
  padRight(width: number, padChar?: string): string
  repeat(count: number): string
  format(...args: readonly unknown[]): string
  indexOfAny(chars: readonly string[]): number
  endsWith(suffix: string): boolean
  startsWith(prefix: string): boolean
  includes(str: string): boolean
}

interface Array<T> {
  indexOfAny(items: readonly T[]): number
  includes(item: T): boolean
}

declare function assert(cond: any, msg?: string): asserts cond
declare function assertNonNull<T>(cond: T, nameof?: string): asserts cond is NonNullable<T>
declare function assertFile(path: string): void
declare function assertPathValid(path: string): void
declare function logAndShow(loglevel: mp.LogLevel, msg: string): void

declare const Env: typeof import('env')
