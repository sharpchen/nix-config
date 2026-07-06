interface String {
  padLeft(width: number, padChar?: string): string
  padRight(width: number, padChar?: string): string
  repeat(count: number): string
}

declare function assert(cond: any, msg?: string): asserts cond
declare function assertNonNull<T>(cond: T, nameof?: string): asserts cond is NonNullable<T>

declare var Env: typeof import('env')
