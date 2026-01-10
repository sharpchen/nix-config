param (
    [ushort]$Port = 5037
)

$null = Get-Command adb -ErrorAction Stop -CommandType Application

adb -P $Port start-server

if ($LASTEXITCODE -ne 0) {
    throw "Fail to start adb server at port $Port, please try another port"
}
