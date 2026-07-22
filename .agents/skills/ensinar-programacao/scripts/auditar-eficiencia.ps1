[CmdletBinding()]
param(
    [ValidateSet('texto', 'json')]
    [string]$Formato = 'texto'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\..\..')).Path
$checks = New-Object 'System.Collections.Generic.List[object]'

function Add-Check {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][ValidateSet('ok', 'atencao', 'erro')][string]$Status,
        [Parameter(Mandatory = $true)][string]$Evidence
    )

    $checks.Add([pscustomobject]@{
        nome = $Name
        status = $Status
        evidencia = $Evidence
    }) | Out-Null
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)
    Get-Content -Raw -Encoding UTF8 -LiteralPath $Path | ConvertFrom-Json
}

$stateRoot = Join-Path $projectRoot 'learning\state'
$jsonFiles = @(Get-ChildItem -LiteralPath $stateRoot -Filter '*.json' -File)
$jsonErrors = @()

foreach ($file in $jsonFiles) {
    try {
        $null = Read-JsonFile $file.FullName
    }
    catch {
        $jsonErrors += "$($file.Name): $($_.Exception.Message)"
    }
}

if ($jsonErrors.Count -eq 0) {
    Add-Check 'JSON de estado' 'ok' "$($jsonFiles.Count) arquivos válidos."
}
else {
    Add-Check 'JSON de estado' 'erro' ($jsonErrors -join '; ')
}

$textFiles = @(
    Get-Item -LiteralPath (Join-Path $projectRoot 'AGENTS.md'), (Join-Path $projectRoot 'README.md'), (Join-Path $projectRoot '.editorconfig'), (Join-Path $projectRoot '.gitattributes'), (Join-Path $projectRoot '.gitignore')
    Get-ChildItem -LiteralPath (Join-Path $projectRoot '.agents') -Recurse -File
    Get-ChildItem -LiteralPath (Join-Path $projectRoot '.codex') -Recurse -File
    Get-ChildItem -LiteralPath (Join-Path $projectRoot 'learning') -Recurse -File
    Get-ChildItem -LiteralPath (Join-Path $projectRoot 'setup') -Recurse -File
) | Where-Object { $_.Extension -in @('.md', '.json', '.toml', '.yaml', '.yml', '.ps1', '.cmd', '.txt') -or $_.Name -in @('.editorconfig', '.gitattributes', '.gitignore') }

$strictUtf8 = New-Object System.Text.UTF8Encoding($false, $true)
$encodingErrors = @()
foreach ($file in $textFiles) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName, $strictUtf8)
        if ($content.Contains([char]0xFFFD)) {
            $encodingErrors += "$($file.FullName): contém caractere de substituição."
        }
    }
    catch {
        $encodingErrors += "$($file.FullName): não é UTF-8 válido."
    }
}

if ($encodingErrors.Count -eq 0) {
    Add-Check 'Codificação UTF-8' 'ok' "$($textFiles.Count) arquivos de texto verificados."
}
else {
    Add-Check 'Codificação UTF-8' 'erro' ($encodingErrors -join '; ')
}

$lineEndingErrors = @()
foreach ($file in $textFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $hasCrlf = $content.Contains("`r`n")
    $hasBareLf = $content.Replace("`r`n", '').Contains("`n")
    $expectsCrlf = $file.Extension -in @('.ps1', '.cmd')

    if ($expectsCrlf -and ($hasBareLf -or (-not $hasCrlf -and $content.Contains("`n")))) {
        $lineEndingErrors += "$($file.FullName): esperado CRLF."
    }
    elseif (-not $expectsCrlf -and $hasCrlf) {
        $lineEndingErrors += "$($file.FullName): esperado LF."
    }
}

if ($lineEndingErrors.Count -eq 0) {
    Add-Check 'Finais de linha' 'ok' 'Arquivos de texto seguem LF; scripts Windows seguem CRLF.'
}
else {
    Add-Check 'Finais de linha' 'erro' ($lineEndingErrors -join '; ')
}

$powerShellScripts = @($textFiles | Where-Object { $_.Extension -eq '.ps1' })
$scriptsWithoutBom = @($powerShellScripts | Where-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    $bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF
})

if ($scriptsWithoutBom.Count -eq 0) {
    Add-Check 'Compatibilidade PowerShell 5.1' 'ok' "$($powerShellScripts.Count) scripts com UTF-8 BOM."
}
else {
    Add-Check 'Compatibilidade PowerShell 5.1' 'erro' ("Scripts sem UTF-8 BOM: " + (($scriptsWithoutBom.FullName) -join ', '))
}

$powerShell7Command = Get-Command 'pwsh.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($powerShell7Command) {
    $powerShell7Version = & $powerShell7Command.Source -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
    Add-Check 'PowerShell 7' 'ok' "Versão $powerShell7Version em $($powerShell7Command.Source)."
}
else {
    Add-Check 'PowerShell 7' 'erro' 'pwsh.exe não foi encontrado no PATH do processo.'
}

$executionPolicy = Get-ExecutionPolicy
$currentUserPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentUserPolicy -in @('RemoteSigned', 'AllSigned') -and $executionPolicy -in @('RemoteSigned', 'AllSigned', 'Bypass')) {
    Add-Check 'Política de execução' 'ok' "CurrentUser: $currentUserPolicy; efetiva no processo: $executionPolicy."
}
else {
    Add-Check 'Política de execução' 'erro' "CurrentUser: $currentUserPolicy; efetiva no processo: $executionPolicy."
}

$venvPython = Join-Path $projectRoot '.venv\Scripts\python.exe'
$requirementsPath = Join-Path $projectRoot 'setup\requirements-tools.txt'
if (-not (Test-Path -LiteralPath $venvPython -PathType Leaf)) {
    Add-Check 'Ambiente Python isolado' 'erro' '.venv\Scripts\python.exe não foi encontrado.'
}
elseif (-not (Test-Path -LiteralPath $requirementsPath -PathType Leaf)) {
    Add-Check 'Ambiente Python isolado' 'erro' 'setup\requirements-tools.txt não foi encontrado.'
}
else {
    $yamlVersion = & $venvPython -X utf8 -c 'import yaml; print(yaml.__version__)'
    if ($LASTEXITCODE -eq 0) {
        Add-Check 'Ambiente Python isolado' 'ok' "PyYAML $yamlVersion disponível na .venv."
    }
    else {
        Add-Check 'Ambiente Python isolado' 'erro' 'A importação de PyYAML falhou na .venv.'
    }

    $validator = Join-Path $env:USERPROFILE '.codex\skills\.system\skill-creator\scripts\quick_validate.py'
    if (Test-Path -LiteralPath $validator -PathType Leaf) {
        $skillRoot = Join-Path $projectRoot '.agents\skills\ensinar-programacao'
        $validatorOutput = & $venvPython -X utf8 $validator $skillRoot 2>&1
        if ($LASTEXITCODE -eq 0) {
            Add-Check 'Validação oficial da skill' 'ok' ($validatorOutput -join ' ')
        }
        else {
            Add-Check 'Validação oficial da skill' 'erro' ($validatorOutput -join ' ')
        }
    }
    else {
        Add-Check 'Validação oficial da skill' 'atencao' "Validador não encontrado: $validator"
    }
}

$progress = Read-JsonFile (Join-Path $stateRoot 'progresso.json')
$reviews = Read-JsonFile (Join-Path $stateRoot 'revisoes.json')
$profile = Read-JsonFile (Join-Path $stateRoot 'perfil.json')
$roadmap = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectRoot 'learning\roadmap.md')

$pendingReviews = @($reviews.fila | Where-Object { $_.status -eq 'pendente' })
$observedSkillIds = @($progress.habilidadesObservadas | ForEach-Object { $_.id })
$currentModules = @($progress.modulos | Where-Object { $_.id -eq $progress.moduloAtual })
$stateRelationErrors = @()

if ($currentModules.Count -ne 1 -or $currentModules[0].status -ne 'em_andamento') {
    $stateRelationErrors += 'moduloAtual não corresponde a um único módulo em_andamento.'
}

if ($progress.ultimaSessao.modulo -ne $progress.moduloAtual) {
    $stateRelationErrors += 'ultimaSessao.modulo diverge de moduloAtual.'
}

$lastSessionLog = Join-Path $projectRoot ("learning\logs\" + $progress.ultimaSessao.data + '.md')
if (-not (Test-Path -LiteralPath $lastSessionLog -PathType Leaf)) {
    $stateRelationErrors += "log da última sessão ausente: $lastSessionLog"
}

$orphanPendingReviews = @($pendingReviews | Where-Object { $observedSkillIds -notcontains $_.habilidade })
if ($orphanPendingReviews.Count -gt 0) {
    $stateRelationErrors += 'revisões pendentes sem habilidade observada: ' + (($orphanPendingReviews.habilidade) -join ', ')
}

if ($stateRelationErrors.Count -eq 0) {
    Add-Check 'Relações do estado pedagógico' 'ok' 'Módulo, última sessão, log e revisões pendentes estão relacionados.'
}
else {
    Add-Check 'Relações do estado pedagógico' 'erro' ($stateRelationErrors -join '; ')
}

$observedVersions = [ordered]@{
    node = $null
    npm = $null
    npx = $null
    git = $null
    vscode = $null
    powershell = $null
    windowsPowerShell = $null
    python = $null
    pipVenv = $null
    pyyamlVenv = $null
}

if ($powerShell7Command) {
    $observedVersions.powershell = [string]$powerShell7Version
}

$windowsPowerShellCommand = Get-Command 'powershell.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($windowsPowerShellCommand) {
    $observedVersions.windowsPowerShell = [string](& $windowsPowerShellCommand.Source -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()')
}

$nodeCommand = Get-Command 'node.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($nodeCommand) {
    $observedVersions.node = ([string](& $nodeCommand.Source --version)).Trim().TrimStart('v')
}

$npmCommand = Get-Command 'npm.cmd' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($npmCommand) {
    $observedVersions.npm = ([string](& $npmCommand.Source --version)).Trim()
}

$npxCommand = Get-Command 'npx.cmd' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($npxCommand) {
    $observedVersions.npx = ([string](& $npxCommand.Source --version)).Trim()
}

$gitCommand = Get-Command 'git.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($gitCommand) {
    $observedVersions.git = (([string](& $gitCommand.Source --version)).Trim() -replace '^git version\s+', '')
}

$codeCommand = Get-Command 'code.cmd' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($codeCommand) {
    $codeOutput = @(& $codeCommand.Source --version)
    if ($codeOutput.Count -gt 0) {
        $observedVersions.vscode = ([string]$codeOutput[0]).Trim()
    }
}

if (Test-Path -LiteralPath $venvPython -PathType Leaf) {
    $observedVersions.python = ([string](& $venvPython -X utf8 -c 'import sys;print(sys.version.split()[0])')).Trim()
    $pipOutput = ([string](& $venvPython -X utf8 -m pip --version)).Trim()
    if ($pipOutput -match '^pip\s+(\S+)') {
        $observedVersions.pipVenv = $Matches[1]
    }
    $observedVersions.pyyamlVenv = ([string](& $venvPython -X utf8 -c 'import yaml;print(yaml.__version__)')).Trim()
}

$environmentDifferences = @()
foreach ($entry in $observedVersions.GetEnumerator()) {
    $expectedProperty = $profile.ambienteObservado.ferramentas.PSObject.Properties[$entry.Key]
    if ($null -eq $expectedProperty) {
        $environmentDifferences += "$($entry.Key): ausente no perfil."
    }
    elseif ([string]::IsNullOrWhiteSpace([string]$entry.Value)) {
        $environmentDifferences += "$($entry.Key): registrado como $($expectedProperty.Value), mas não observado."
    }
    elseif ([string]$expectedProperty.Value -ne [string]$entry.Value) {
        $environmentDifferences += "$($entry.Key): perfil $($expectedProperty.Value), observado $($entry.Value)."
    }
}

$gitInitialized = Test-Path -LiteralPath (Join-Path $projectRoot '.git') -PathType Container
if ([bool]$profile.ambienteObservado.repositorioGitInicializado -ne $gitInitialized) {
    $environmentDifferences += "repositorioGitInicializado: perfil $($profile.ambienteObservado.repositorioGitInicializado), observado $gitInitialized."
}

if ($environmentDifferences.Count -eq 0) {
    Add-Check 'Perfil do ambiente' 'ok' 'Versões e estado do Git correspondem ao perfil canônico.'
}
else {
    Add-Check 'Perfil do ambiente' 'atencao' ($environmentDifferences -join '; ')
}

if ($roadmap -match '(?m)^Status atual:' -or $roadmap -match '(?m)^## Próximo marco') {
    Add-Check 'Roadmap estável' 'atencao' 'O roadmap ainda contém estado operacional mutável.'
}
else {
    Add-Check 'Roadmap estável' 'ok' 'O roadmap aponta para a fonte canônica sem duplicar o estado atual.'
}

$agentFiles = @(Get-ChildItem -LiteralPath (Join-Path $projectRoot '.codex\agents') -Filter '*.toml' -File)
$mutableAgents = @($agentFiles | Where-Object {
    (Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName) -notmatch 'sandbox_mode\s*=\s*"read-only"'
})

if ($mutableAgents.Count -eq 0) {
    Add-Check 'Agentes especializados' 'ok' "$($agentFiles.Count) agentes com sandbox somente leitura."
}
else {
    Add-Check 'Agentes especializados' 'atencao' ("Sem declaração somente leitura: " + (($mutableAgents.Name) -join ', '))
}

$currentModulePath = Join-Path $projectRoot ("learning\modules\" + $progress.moduloAtual)
if (Test-Path -LiteralPath $currentModulePath -PathType Container) {
    Add-Check 'Material do módulo atual' 'ok' "Diretório encontrado para $($progress.moduloAtual)."
}
else {
    Add-Check 'Material do módulo atual' 'atencao' "Ainda não há diretório para $($progress.moduloAtual); criar conteúdo continua dependendo de autorização e necessidade pedagógica."
}

$stateMetrics = @($jsonFiles | ForEach-Object {
    [pscustomobject]@{
        arquivo = $_.Name
        bytes = $_.Length
        linhas = (Get-Content -LiteralPath $_.FullName).Count
    }
})

$result = [ordered]@{
    schemaVersion = 1
    geradoEm = (Get-Date).ToString('s')
    moduloAtual = $progress.moduloAtual
    revisoesPendentes = $pendingReviews.Count
    metricasEstado = $stateMetrics
    verificacoes = $checks
}

if ($Formato -eq 'json') {
    $result | ConvertTo-Json -Depth 6
}
else {
    Write-Output "Auditoria de eficiência — $($result.geradoEm)"
    Write-Output "Módulo atual: $($result.moduloAtual); revisões pendentes: $($result.revisoesPendentes)."
    foreach ($check in $checks) {
        Write-Output "[$($check.status.ToUpperInvariant())] $($check.nome): $($check.evidencia)"
    }
    Write-Output 'Tamanho do estado:'
    foreach ($metric in $stateMetrics) {
        Write-Output "- $($metric.arquivo): $($metric.bytes) bytes, $($metric.linhas) linhas"
    }
}

if (@($checks | Where-Object { $_.status -eq 'erro' }).Count -gt 0) {
    exit 1
}
