$pageTemplate = Get-Content -Raw "./indexTemplate.html"
$itemTemplate = Get-Content -Raw "./tableElement.html"

$indexChildItems  = Get-ChildItem
$itemHtmlString   = ""

foreach ($item in $indexChildItems) {
  # $item | `
  #  Format-List -Property FullName,Name,BaseName,Extension,Length
  $thing = $itemTemplate -f ($item.FullName,$item.Name,$item.BaseName,$item.Extension,$item.Length)
  ($itemHtmlString += $thing) | Out-Null
}

# Write-Host $itemHtmlString


