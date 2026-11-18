$ErrorActionPreference = "Stop"
$php = "C:\Users\USER\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe"
$project = "C:\Users\USER\Projects\NilricERP"
Set-Location $project
$env:PATH = "C:\Users\USER\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe;C:\Users\USER\bin;$env:PATH"
$env:PHP_INI_SCAN_DIR = Join-Path $project "dev\php\conf.d"

$mysqlRoot = Join-Path $project "storage\local-mysql"
$mysqlBase = Join-Path $mysqlRoot "dist\mysql-8.4.13-winx64"
$mysqlServer = Join-Path $mysqlBase "bin\mysqld.exe"
$mysqlClient = Join-Path $mysqlBase "bin\mysql.exe"
$mysqlIni = Join-Path $mysqlRoot "my.ini"
$mysqlCredentials = Join-Path $mysqlRoot "app-client.cnf"

foreach ($requiredPath in @($mysqlServer, $mysqlClient, $mysqlIni, $mysqlCredentials)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Local MySQL setup is incomplete. Missing: $requiredPath"
    }
}

$mysqlArguments = @(
    "--defaults-extra-file=$mysqlCredentials",
    "--database=nilricerp",
    "--batch",
    "--skip-column-names",
    "--execute=SELECT 1"
)

& $mysqlClient @mysqlArguments 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    $mysqlStdout = Join-Path $mysqlRoot "mysqld-stdout.log"
    $mysqlStderr = Join-Path $mysqlRoot "mysqld-stderr.log"
    $mysqlServerProcess = Start-Process `
        -FilePath $mysqlServer `
        -ArgumentList @("--defaults-file=$mysqlIni", "--console") `
        -WorkingDirectory $mysqlBase `
        -WindowStyle Hidden `
        -RedirectStandardOutput $mysqlStdout `
        -RedirectStandardError $mysqlStderr `
        -PassThru

    $mysqlIsReady = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        Start-Sleep -Seconds 1
        & $mysqlClient @mysqlArguments 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $mysqlIsReady = $true
            break
        }

        if ($mysqlServerProcess.HasExited) {
            break
        }
    }

    if (-not $mysqlIsReady) {
        throw "Local MySQL failed to start. Check $mysqlStderr."
    }
}

$opcacheInfo = & $php --ri 'Zend OPcache' 2>&1
if ($LASTEXITCODE -ne 0 -or ($opcacheInfo -join "`n") -notmatch 'Opcode Caching => Up and Running') {
    throw "PHP OPcache did not load. Check dev\php\conf.d\10-opcache.ini."
}

& $php artisan nilric:ensure-organization --no-interaction
if ($LASTEXITCODE -ne 0) {
    throw "Could not ensure Nilric departments, positions, and roles are present."
}

& $php artisan serve --host=localhost --port=8000 --no-reload
