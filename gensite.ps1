$pageTemplate = Get-Content -Raw "./indexTemplate.html"
$itemTemplate = Get-Content -Raw "./tableElement.html"

Get-ChildItem -Recurse | ForEach-Object -Process {
  $file             = ($pageTemplate | Out-File "$_\index.html" -Force)
  $indexChildItems  = Get-ChildItem $file
  $itemHtmlString   = ""

  foreach ($item in $indexChildItems) {
    $thing = $itemTemplate -f ($item.FullName,$item.Name,$item.BaseName,$item.Extension,$item.Length)
    $itemHtmlString += $thing)ll
  }
  $pageTemplate -f $indexHtmlString | Out-File "$_\index.html" -Force 
}


# Write-Host $itemHtmlString


