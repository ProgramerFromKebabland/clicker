param(
    [Parameter(Mandatory = $true)]
    [string[]]$Paths,

    [string]$BackupDirectory
)

Add-Type -AssemblyName System.Drawing
if ([string]::IsNullOrWhiteSpace($BackupDirectory)) {
    $BackupDirectory = Join-Path $PSScriptRoot "image_backups"
}
New-Item -ItemType Directory -Path $BackupDirectory -Force | Out-Null

foreach ($path in $Paths) {
    $resolved = (Resolve-Path -LiteralPath $path).Path
    $source = [System.Drawing.Bitmap]::new($resolved)
    $image = [System.Drawing.Bitmap]::new(
        $source.Width,
        $source.Height,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    )

    $graphics = [System.Drawing.Graphics]::FromImage($image)
    $graphics.DrawImageUnscaled($source, 0, 0)
    $graphics.Dispose()
    $source.Dispose()

    $cornerColors = @(
        $image.GetPixel(0, 0),
        $image.GetPixel([Math]::Min(40, $image.Width - 1), 0),
        $image.GetPixel(0, [Math]::Min(40, $image.Height - 1)),
        $image.GetPixel([Math]::Min(40, $image.Width - 1), [Math]::Min(40, $image.Height - 1))
    )

    $isBackground = {
        param([System.Drawing.Color]$pixel)

        foreach ($sample in $cornerColors) {
            $dr = [int]$pixel.R - [int]$sample.R
            $dg = [int]$pixel.G - [int]$sample.G
            $db = [int]$pixel.B - [int]$sample.B
            if (($dr * $dr + $dg * $dg + $db * $db) -le 180) {
                return $true
            }
        }

        return $false
    }

    $width = $image.Width
    $height = $image.Height
    $visited = [bool[]]::new($width * $height)
    $queue = [System.Collections.Generic.Queue[int]]::new()

    for ($x = 0; $x -lt $width; $x++) {
        $queue.Enqueue($x)
        $queue.Enqueue(($height - 1) * $width + $x)
    }
    for ($y = 1; $y -lt $height - 1; $y++) {
        $queue.Enqueue($y * $width)
        $queue.Enqueue($y * $width + $width - 1)
    }

    while ($queue.Count -gt 0) {
        $index = $queue.Dequeue()
        if ($visited[$index]) {
            continue
        }
        $visited[$index] = $true

        $x = $index % $width
        $y = [Math]::Floor($index / $width)
        $pixel = $image.GetPixel($x, $y)
        if (-not (& $isBackground $pixel)) {
            continue
        }

        $image.SetPixel($x, $y, [System.Drawing.Color]::Transparent)

        if ($x -gt 0) { $queue.Enqueue($index - 1) }
        if ($x -lt $width - 1) { $queue.Enqueue($index + 1) }
        if ($y -gt 0) { $queue.Enqueue($index - $width) }
        if ($y -lt $height - 1) { $queue.Enqueue($index + $width) }
    }

    $backup = Join-Path $BackupDirectory ([System.IO.Path]::GetFileName($resolved))
    if (-not (Test-Path -LiteralPath $backup)) {
        Copy-Item -LiteralPath $resolved -Destination $backup
    }

    $temporary = "$resolved.cleaned.png"
    $image.Save($temporary, [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose()
    Move-Item -LiteralPath $temporary -Destination $resolved -Force
}
