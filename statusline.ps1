$data = $null
try { $data = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { $data = $null }

$modelId = $null
if ($data) { $modelId = $data.model.id }
if (-not $modelId) { $modelId = "" }
$model = $modelId -replace '^claude-', '' -replace '-\d{8}$', ''
if ([string]::IsNullOrEmpty($model)) {
    $model = $null
    if ($data) { $model = $data.model.display_name }
    if (-not $model) { $model = "unknown" }
}

$ctxPct = $null
$fiveHourPct = $null
$weekPct = $null
if ($data) {
    $ctxPct = $data.context_window.used_percentage
    $fiveHourPct = $data.rate_limits.five_hour.used_percentage
    $weekPct = $data.rate_limits.seven_day.used_percentage
}

$midParts = @()
if ($null -ne $ctxPct) { $midParts += ("ctx {0:N0}%" -f [double]$ctxPct) }
if ($null -ne $fiveHourPct) { $midParts += ("5h {0:N0}%" -f [double]$fiveHourPct) }
if ($null -ne $weekPct) { $midParts += ("7d {0:N0}%" -f [double]$weekPct) }
$mid = $midParts -join ", "

$cwd = $null
if ($data) {
    $cwd = $data.workspace.current_dir
    if ($null -eq $cwd) { $cwd = $data.cwd }
}
if (-not $cwd) { $cwd = "" }

$branch = $null
$gitAvailable = [bool](Get-Command git -ErrorAction SilentlyContinue)
if ($gitAvailable -and $cwd) {
    # Candidate subdirs are a literal port of the source script's own repo layout.
    $candidates = @($cwd, (Join-Path $cwd "sim"), (Join-Path $cwd "tracker"), (Join-Path $cwd "socket-sniffer"))
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            try {
                $result = git -C "$candidate" --no-optional-locks rev-parse --abbrev-ref HEAD 2>$null
            } catch {
                $result = $null
            }
            if ($LASTEXITCODE -eq 0 -and $result) {
                $branch = ($result | Select-Object -First 1).Trim()
                if ($branch) { break }
            }
        }
    }
}

$out = $model
if ($mid) { $out = "$out | $mid" }
if ($branch) { $out = "$out | git $branch" }

[Console]::Out.Write($out)
