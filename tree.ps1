<#
.VERSION
	1.0
.SYNOPSIS
    Acts like tree in Windows but is more configurable and lists hidden files.
.AUTHOR
    KaimoSec (https://github.com/kaimosec) & ChatGPT
.PARAMETER path
    The root path to begin tree-ing in.
.PARAMETER maxLevel
    The recursion depth.
    0 = Recurse indefinitely
    1 = List files in current directory
    2 = List files and sub directories
    3 = etc...
.EXAMPLES
    Load the function into powershell
        . .\tree.ps1
    Tree from current location, indefinitely
        Tree "." 0
    Show files and subfiles from C:\
        Tree "C:\" 0
    Tree from current location, showing current files and the next level down
        Tree "." 2
#>

function Recurse($path, $level, $maxLevel) {
    $indent = ' | ' * $level
    $items = Get-ChildItem $path -Force -ErrorVariable err -ErrorAction SilentlyContinue
    if ($err) {
        Write-Host $indent"ACCESS DENIED"
    }
    foreach ($item in $items) {
        Write-Host "$indent$item"

        if ($item -is [System.IO.DirectoryInfo]) {
            if ((($level + 1) -lt $maxLevel) -or ($maxLevel -eq '0')) {
                Recurse $item.FullName ($level + 1) $maxLevel
            }
        }
    }
}

function Tree($path, $maxlevel) {
    Recurse $path 0 $maxlevel;
}
