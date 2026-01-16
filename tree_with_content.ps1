param (
    [string]$RootPath = ".",
    [string]$OutputFile = "tree_with_content.txt"
)

function Write-Tree {
    param (
        [string]$Path,
        [string]$Prefix = ""
    )

    $items = Get-ChildItem $Path | Sort-Object PSIsContainer, Name

    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)

        $branch = if ($isLast) { "\---" } else { "+---" }
        $nextPrefix = if ($isLast) { "$Prefix    " } else { "$Prefix|   " }

        Add-Content $OutputFile "$Prefix$branch $($item.Name)"

        if ($item.PSIsContainer) {
            Write-Tree -Path $item.FullName -Prefix $nextPrefix
        }
        else {
            # Print file contents (only text files)
            try {
                $content = Get-Content $item.FullName -ErrorAction Stop
                foreach ($line in $content) {
                    Add-Content $OutputFile "$nextPrefix$line"
                }
            } catch {
                Add-Content $OutputFile "$nextPrefix<binary or unreadable file>"
            }
        }
    }
}

# Clear output file
"" | Set-Content $OutputFile

# Start
Write-Tree -Path $RootPath

# run this command in powershell to generate the tree:
# powershell -ExecutionPolicy Bypass -File tree_with_content.ps1 -RootPath lib -OutputFile tree.txt

#run and modify the path for specific directory
# powershell -ExecutionPolicy Bypass -File tree_with_content.ps1 -RootPath "lib/features/vehicle_management/widgets/stepper/content" -OutputFile "stepper_tree.txt"