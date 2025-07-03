param(
  [string]$rootPath=$PSScriptRoot
)

$rootPageTemplate   = Get-Content -Raw "$rootPath\.html\indexTemplate.html"
$subPageTemplate    = Get-Content -Raw "$rootPath\.html\subIndexTemplate.html"
$itemTemplate       = Get-Content -Raw "$rootPath\.html\tableElement.html"

$excludedFiles      = @( ".*", "index.html" )
$excludedFolders    = @( ".*" )

function generateContents
{
  param(
    [Parameter(Mandatory)]
    [string]$folderLocation,
    [string]$parentLocation
  )
  
  Write-Host $folderLocation -ForegroundColor Red
  Write-Host $parentLocation -ForegroundColor Red

  $childItems       = Get-ChildItem $folderLocation -Exclude $excludedFiles 
  $itemsHtmlString  = ""
    
  foreach ($item in $childItems)
  {
    $formattedTableRow = ($itemTemplate -f (`
        $item.Name,
        $item.Name,
        $item.BaseName,
        $item.Extension,
        $item.Length
      )).Trim()
    $itemsHtmlString += $formattedTableRow
  }
  
  if (-not $parentLocation)
  {
    ($rootPageTemplate -f $itemsHtmlString) |`
      Out-File "$folderLocation\index.html" -Force
  } else
  {
    ($subPageTemplate -f "../$($parentLocation.BaseName)",$itemsHtmlString) |`
      Out-File "$folderLocation\index.html" -Force
  }
}

# Recursively for each subfolder
Get-ChildItem -Path $rootPath -Directory -Recurse -Exclude $excludedFolders |`
  ForEach-Object -Process {
    generateContents `
      -folderLocation $_ `
      -parentLocation $_.Parent
  }

# For the root directory
generateContents `
  -folderLocation $rootPath

