param(
  [string]$rootPath=$PSScriptRoot
)

$rootPageTemplate       = Get-Content -Raw "$rootPath\.html\indexTemplate.html"
$subPageTemplate        = Get-Content -Raw "$rootPath\.html\subIndexTemplate.html"
$websiteHeaderTemplate  = Get-Content -Raw "$rootPath\.html\websiteHeader.html"
$itemTemplate           = Get-Content -Raw "$rootPath\.html\tableElement.html"

$excludedFiles      = @( ".*", "index.html" )
$excludedFolders    = @( ".*" )
$headerStrings      = @(
  "https://betterlordwilliam.github.io/PublicPictures/images/Epic.png",
  ""
)


function generateHeader
{
  <#
  Generates the header for a website page.
  #>
  param(
    [Parameter(Mandatory)]
    [string]$pageTitle
  )

  return ($websiteHeaderTemplate -f (, $pageTitle + $headerStrings)).Trim()
}


function generateContents
{
  <#
  Generates the contents of the site, adding new table items for each sub item.
  #>
  param(
    [Parameter(Mandatory)]
    [string]$folderLocation,
    [string]$parentLocation,
    [string]$pageTitle="Will Epic Website"
  )
  
  Write-Host $folderLocation -ForegroundColor Red
  Write-Host $parentLocation -ForegroundColor Red
  
  $headerString     = generateHeader $pageTitle
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
    ($rootPageTemplate -f $headerString, $itemsHtmlString) |`
        Out-File "$folderLocation\index.html" -Force
  } else
  {
    ($subPageTemplate -f $headerString, "../$($parentLocation.BaseName)",$itemsHtmlString) |`
        Out-File "$folderLocation\index.html" -Force
  }
}


# Recursively for each subfolder
Get-ChildItem -Path $rootPath -Directory -Recurse -Exclude $excludedFolders |`
    ForEach-Object -Process {
    generateContents `
      -folderLocation $_ `
      -parentLocation $_.Parent `
      -pageTitle $_.FullName
  }

# For the root directory
generateContents `
  -folderLocation $rootPath

