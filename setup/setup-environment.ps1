[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Step {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)][string]$Executable,
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    $commandOutput = & $Executable @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    foreach ($line in $commandOutput) {
        Write-Host $line
    }

    if ($exitCode -ne 0) {
        throw "O comando falhou com código ${exitCode}: $Executable $($Arguments -join ' ')"
    }
}

function Get-PowerShell7Command {
    $command = Get-Command 'pwsh.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) {
        return $command.Source
    }

    $installBase = Join-Path $env:LOCALAPPDATA 'Programs\PowerShell'
    if (Test-Path -LiteralPath $installBase -PathType Container) {
        $localInstall = Get-ChildItem -LiteralPath $installBase -Directory |
            Sort-Object { try { [version]$_.Name } catch { [version]'0.0' } } -Descending |
            ForEach-Object { Join-Path $_.FullName 'pwsh.exe' } |
            Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
            Select-Object -First 1

        if ($localInstall) {
            return $localInstall
        }
    }

    return $null
}

function Install-UserPowerShell7 {
    Write-Step 'Instalando PowerShell 7 no perfil do usuário'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $headers = @{ 'User-Agent' = 'EstudandoReact-Setup' }
    $releaseUri = 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'
    $release = Invoke-RestMethod -UseBasicParsing -Headers $headers -Uri $releaseUri

    if ($release.prerelease -or $release.draft) {
        throw 'A API retornou uma versão preliminar ou rascunho; instalação cancelada.'
    }

    $architecture = if ($env:PROCESSOR_ARCHITECTURE -match 'ARM64') { 'arm64' } else { 'x64' }
    $version = ([string]$release.tag_name).TrimStart('v')
    $assetName = "PowerShell-$version-win-$architecture.zip"
    $asset = @($release.assets | Where-Object { $_.name -eq $assetName } | Select-Object -First 1)

    if ($asset.Count -ne 1) {
        throw "Pacote oficial não encontrado na release $($release.tag_name): $assetName"
    }

    $installBase = Join-Path $env:LOCALAPPDATA 'Programs\PowerShell'
    $installRoot = Join-Path $installBase $version
    $resolvedLocalAppData = [System.IO.Path]::GetFullPath($env:LOCALAPPDATA)
    $resolvedInstallRoot = [System.IO.Path]::GetFullPath($installRoot)

    if (-not $resolvedInstallRoot.StartsWith($resolvedLocalAppData, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Destino de instalação inválido: $resolvedInstallRoot"
    }

    if (-not (Test-Path -LiteralPath (Join-Path $installRoot 'pwsh.exe') -PathType Leaf)) {
        $temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("EstudandoReact-PowerShell-" + [guid]::NewGuid().ToString('N'))
        $archivePath = Join-Path $temporaryRoot $assetName
        $extractRoot = Join-Path $temporaryRoot 'extract'

        try {
            New-Item -ItemType Directory -Force -Path $temporaryRoot, $extractRoot | Out-Null
            Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $asset[0].browser_download_url -OutFile $archivePath

            $expectedHash = $null
            if ($asset[0].PSObject.Properties.Name -contains 'digest' -and $asset[0].digest -match '^sha256:(.+)$') {
                $expectedHash = $Matches[1]
            }
            else {
                $hashAsset = @($release.assets | Where-Object { $_.name -eq 'hashes.sha256' } | Select-Object -First 1)
                if ($hashAsset.Count -ne 1) {
                    throw 'Arquivo oficial hashes.sha256 não encontrado.'
                }

                $hashPath = Join-Path $temporaryRoot 'hashes.sha256'
                Invoke-WebRequest -UseBasicParsing -Headers $headers -Uri $hashAsset[0].browser_download_url -OutFile $hashPath
                $hashLine = Get-Content -LiteralPath $hashPath | Where-Object { $_ -match [regex]::Escape($assetName) } | Select-Object -First 1
                if ($hashLine -match '^([A-Fa-f0-9]{64})') {
                    $expectedHash = $Matches[1]
                }
            }

            if (-not $expectedHash) {
                throw "Hash SHA-256 oficial não encontrado para $assetName"
            }

            $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $archivePath).Hash
            if ($actualHash -ne $expectedHash) {
                throw "Hash inválido para $assetName. Esperado: $expectedHash; recebido: $actualHash"
            }

            Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot -Force
            New-Item -ItemType Directory -Force -Path $installRoot | Out-Null
            Copy-Item -Path (Join-Path $extractRoot '*') -Destination $installRoot -Recurse -Force
        }
        finally {
            if (Test-Path -LiteralPath $temporaryRoot) {
                $resolvedTemporaryRoot = [System.IO.Path]::GetFullPath($temporaryRoot)
                $resolvedSystemTemp = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
                if (-not $resolvedTemporaryRoot.StartsWith($resolvedSystemTemp, [System.StringComparison]::OrdinalIgnoreCase)) {
                    throw "Diretório temporário fora do local esperado: $resolvedTemporaryRoot"
                }
                Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
            }
        }
    }

    $powerShellPath = Join-Path $installRoot 'pwsh.exe'
    if (-not (Test-Path -LiteralPath $powerShellPath -PathType Leaf)) {
        throw "PowerShell 7 não foi encontrado após a instalação: $powerShellPath"
    }

    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $pathEntries = @($userPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    $installBasePrefix = ([Environment]::ExpandEnvironmentVariables($installBase)).TrimEnd('\') + '\'
    $filteredEntries = @($pathEntries | Where-Object {
        $expandedEntry = ([Environment]::ExpandEnvironmentVariables($_)).Trim().Trim('"').TrimEnd('\') + '\'
        -not $expandedEntry.StartsWith(
            $installBasePrefix,
            [System.StringComparison]::OrdinalIgnoreCase
        )
    })
    $newUserPath = (@($installRoot) + $filteredEntries) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User')
    $env:Path = "$installRoot;$env:Path"

    return $powerShellPath
}

function Set-ProjectExecutionPolicy {
    Write-Step 'Configurando a política de execução do usuário'
    $configuredPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($configuredPolicy -notin @('RemoteSigned', 'AllSigned')) {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
        }
        catch {
            $configuredAfterError = Get-ExecutionPolicy -Scope CurrentUser
            if ($configuredAfterError -notin @('RemoteSigned', 'AllSigned')) {
                throw
            }
        }
        $configuredPolicy = Get-ExecutionPolicy -Scope CurrentUser
    }

    if ($configuredPolicy -notin @('RemoteSigned', 'AllSigned')) {
        throw "Não foi possível persistir RemoteSigned para CurrentUser. Valor observado: $configuredPolicy"
    }

    $effectivePolicy = Get-ExecutionPolicy
    if ($effectivePolicy -notin @('RemoteSigned', 'AllSigned', 'Bypass')) {
        throw "Uma política de maior precedência impede scripts locais. Política efetiva: $effectivePolicy"
    }

    Write-Host "Política persistida em CurrentUser: $configuredPolicy; efetiva neste processo: $effectivePolicy"
}

function Initialize-PythonTooling {
    param([Parameter(Mandatory = $true)][string]$ProjectRoot)

    Write-Step 'Criando o ambiente Python isolado de ferramentas'
    $pythonCommand = Get-Command 'python.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
    $pythonArgumentsPrefix = @()
    if (-not $pythonCommand) {
        $pythonCommand = Get-Command 'py.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
        $pythonArgumentsPrefix = @('-3')
    }
    if (-not $pythonCommand) {
        throw 'Python não foi encontrado como python.exe nem py.exe. Instale uma versão oficial compatível antes de continuar.'
    }

    $pythonVersionText = & $pythonCommand.Source @pythonArgumentsPrefix -c 'import sys; print(sys.version_info.major,sys.version_info.minor,sys.version_info.micro,sep=chr(46))'
    $pythonVersion = [version]$pythonVersionText
    if ($pythonVersion -lt [version]'3.8.0') {
        throw "Python 3.8 ou superior é necessário. Versão observada: $pythonVersion"
    }
    Write-Host "Python base: $pythonVersion ($($pythonCommand.Source))"

    $venvRoot = Join-Path $ProjectRoot '.venv'
    $venvPython = Join-Path $venvRoot 'Scripts\python.exe'
    $requirementsPath = Join-Path $PSScriptRoot 'requirements-tools.txt'

    if (-not (Test-Path -LiteralPath $requirementsPath -PathType Leaf)) {
        throw "Arquivo de dependências não encontrado: $requirementsPath"
    }

    if (-not (Test-Path -LiteralPath $venvPython -PathType Leaf)) {
        Invoke-Checked $pythonCommand.Source (@($pythonArgumentsPrefix) + @('-X', 'utf8', '-m', 'venv', $venvRoot))
    }

    Invoke-Checked $venvPython @('-X', 'utf8', '-m', 'pip', 'install', '--disable-pip-version-check', '--upgrade', 'pip')
    Invoke-Checked $venvPython @('-X', 'utf8', '-m', 'pip', 'install', '--disable-pip-version-check', '-r', $requirementsPath)
    Invoke-Checked $venvPython @('-X', 'utf8', '-m', 'pip', 'check')
    Invoke-Checked $venvPython @('-X', 'utf8', '-c', 'import yaml; print(yaml.__version__)')

    return $venvPython
}

function Test-ProjectTooling {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectRoot,
        [Parameter(Mandatory = $true)][string]$PowerShell7,
        [Parameter(Mandatory = $true)][string]$VenvPython
    )

    Write-Step 'Validando a skill e os scripts do projeto'
    $skillRoot = Join-Path $ProjectRoot '.agents\skills\ensinar-programacao'
    $validator = Join-Path $env:USERPROFILE '.codex\skills\.system\skill-creator\scripts\quick_validate.py'
    if (Test-Path -LiteralPath $validator -PathType Leaf) {
        Invoke-Checked $VenvPython @('-X', 'utf8', $validator, $skillRoot)
    }
    else {
        Write-Warning "Validador oficial não encontrado; a auditoria local continuará verificando a estrutura: $validator"
    }

    $summaryScript = Join-Path $skillRoot 'scripts\resumir-contexto.ps1'
    $auditScript = Join-Path $skillRoot 'scripts\auditar-eficiencia.ps1'
    Invoke-Checked $PowerShell7 @('-NoLogo', '-NoProfile', '-File', $summaryScript, '-Modo', 'retomada', '-LimiteRevisoes', '1')
    Invoke-Checked $PowerShell7 @('-NoLogo', '-NoProfile', '-File', $auditScript)
}

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path

Write-Step 'Verificando PowerShell 7'
$powerShell7 = Get-PowerShell7Command
$installedVersion = $null
if ($powerShell7) {
    $installedVersion = [version](& $powerShell7 -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()')
}

if (-not $powerShell7 -or $installedVersion -lt [version]'7.6.0') {
    $powerShell7 = Install-UserPowerShell7
}

$powerShellDirectory = Split-Path -Parent $powerShell7
if (-not (($env:Path -split ';') -contains $powerShellDirectory)) {
    $env:Path = "$powerShellDirectory;$env:Path"
}

$powerShellVersion = & $powerShell7 -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
Write-Host "PowerShell 7: $powerShellVersion ($powerShell7)"

Set-ProjectExecutionPolicy
$venvPython = Initialize-PythonTooling -ProjectRoot $projectRoot
Test-ProjectTooling -ProjectRoot $projectRoot -PowerShell7 $powerShell7 -VenvPython $venvPython

Write-Host "`nAmbiente configurado com sucesso." -ForegroundColor Green
Write-Host 'Em uma nova janela de terminal, use pwsh para abrir o PowerShell 7.'
