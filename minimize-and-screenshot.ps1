param(
    [string]$WindowTitlePattern = 'openclaw-tui|Windows PowerShell|PowerShell',
    [int]$DelayMs = 700,
    [switch]$RestoreWindow
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class WinApi {
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$SW_MINIMIZE = 6
$SW_RESTORE = 9
$pattern = [regex]::new($WindowTitlePattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
$matched = New-Object System.Collections.Generic.List[System.IntPtr]
$titles = @{}

$callback = [WinApi+EnumWindowsProc]{
    param([IntPtr]$hWnd, [IntPtr]$lParam)

    if (-not [WinApi]::IsWindowVisible($hWnd)) { return $true }

    $sb = New-Object System.Text.StringBuilder 512
    [void][WinApi]::GetWindowText($hWnd, $sb, $sb.Capacity)
    $title = $sb.ToString()

    if (-not [string]::IsNullOrWhiteSpace($title) -and $pattern.IsMatch($title)) {
        $matched.Add($hWnd)
        $titles[$hWnd] = $title
    }

    return $true
}

[void][WinApi]::EnumWindows($callback, [IntPtr]::Zero)

foreach ($hWnd in $matched) {
    [void][WinApi]::ShowWindow($hWnd, $SW_MINIMIZE)
}

Start-Sleep -Milliseconds $DelayMs

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$path = Join-Path $env:USERPROFILE ('Desktop\\minshot-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.png')
$bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

if ($RestoreWindow) {
    Start-Sleep -Milliseconds 300
    foreach ($hWnd in $matched) {
        [void][WinApi]::ShowWindow($hWnd, $SW_RESTORE)
    }
}

[pscustomobject]@{
    path = $path
    minimizedCount = $matched.Count
    minimizedTitles = @($matched | ForEach-Object { $titles[$_] })
} | ConvertTo-Json -Compress
