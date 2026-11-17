$ErrorActionPreference = "Stop"
$php = "C:\Users\USER\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe"
$project = "C:\Users\USER\Projects\NilricERP"
Set-Location $project
$env:PATH = "C:\Users\USER\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe;C:\Users\USER\bin;$env:PATH"
$env:PHP_INI_SCAN_DIR = Join-Path $project "dev\php\conf.d"

$opcacheInfo = & $php --ri 'Zend OPcache' 2>&1
if ($LASTEXITCODE -ne 0 -or ($opcacheInfo -join "`n") -notmatch 'Opcode Caching => Up and Running') {
    throw "PHP OPcache did not load. Check dev\php\conf.d\10-opcache.ini."
}

& $php artisan serve --host=localhost --port=8000 --no-reload
