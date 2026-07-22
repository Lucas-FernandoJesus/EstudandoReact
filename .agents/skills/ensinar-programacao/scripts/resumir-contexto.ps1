[CmdletBinding()]
param(
    [ValidateSet('retomada', 'planejamento', 'completo')]
    [string]$Modo = 'retomada',

    [ValidateSet('texto', 'json')]
    [string]$Formato = 'texto',

    [ValidateRange(1, 20)]
    [int]$LimiteRevisoes = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Arquivo obrigatório não encontrado: $Path"
    }

    Get-Content -Raw -Encoding UTF8 -LiteralPath $Path | ConvertFrom-Json
}

function Get-ReviewRank {
    param([string]$Schedule)

    switch -Regex ($Schedule) {
        'prioridade' { return 0 }
        'proxima_sessao' { return 1 }
        'contexto_real|ao_retomar|antes_de' { return 2 }
        'futura' { return 3 }
        default { return 4 }
    }
}

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\..\..')).Path
$stateRoot = Join-Path $projectRoot 'learning\state'
$progress = Read-JsonFile (Join-Path $stateRoot 'progresso.json')
$reviews = Read-JsonFile (Join-Path $stateRoot 'revisoes.json')
$profile = $null

if ($Modo -in @('planejamento', 'completo')) {
    $profile = Read-JsonFile (Join-Path $stateRoot 'perfil.json')
}

$pendingReviews = @(
    $reviews.fila |
        Where-Object { $_.status -eq 'pendente' } |
        Sort-Object @{ Expression = { Get-ReviewRank $_.agendamento } }, @{ Expression = { $_.id } }
)

$reviewLimit = if ($Modo -eq 'completo') { $pendingReviews.Count } else { $LimiteRevisoes }
$selectedReviews = @($pendingReviews | Select-Object -First $reviewLimit | ForEach-Object {
    [ordered]@{
        id = $_.id
        habilidade = $_.habilidade
        agendamento = $_.agendamento
        atividade = $_.atividade
    }
})

$context = [ordered]@{
    schemaVersion = 1
    modo = $Modo
    moduloAtual = $progress.moduloAtual
    statusGeral = $progress.statusGeral
    ultimaSessao = $progress.ultimaSessao
    revisoesPendentes = $pendingReviews.Count
    revisoesSelecionadas = $selectedReviews
}

if ($Modo -in @('planejamento', 'completo')) {
    $context.objetivoGeral = $profile.objetivoGeral
    $context.modulosAtivos = @($progress.modulos | Where-Object { $_.status -in @('em_andamento', 'em_revisao_contextual') })
}

if ($Modo -eq 'completo') {
    $context.preferencias = $profile.preferencias
    $context.habilidadesObservadas = $progress.habilidadesObservadas
}

if ($Formato -eq 'json') {
    $context | ConvertTo-Json -Depth 8
    exit 0
}

Write-Output "Módulo atual: $($context.moduloAtual)"
Write-Output "Status geral: $($context.statusGeral)"
Write-Output "Última sessão: $($context.ultimaSessao.data) — $($context.ultimaSessao.foco)"
Write-Output "Ponto de retomada: $($context.ultimaSessao.proximaAtividade)"
Write-Output "Revisões pendentes: $($context.revisoesPendentes); exibindo $($selectedReviews.Count)."

foreach ($review in $selectedReviews) {
    Write-Output "- [$($review.agendamento)] $($review.habilidade): $($review.atividade)"
}

if ($Modo -in @('planejamento', 'completo')) {
    Write-Output "Objetivo geral: $($context.objetivoGeral)"
    Write-Output 'Módulos em estudo ou revisão:'
    foreach ($module in $context.modulosAtivos) {
        Write-Output "- $($module.id): $($module.status), domínio $($module.dominio)"
    }
}
