Function _exportPath($items){

  $env_path=[environment]::GetEnvironmentvariable("Path","user")
  $env_path_array=$env_path.split(';') | Sort-Object -unique

  Foreach ($item in $items)
  {
    if(!$item){
      continue;
    }

    if($env_path_array.IndexOf($item) -eq -1){
      "Add $item to system PATH env ...
"
      [environment]::SetEnvironmentvariable("Path", "$item;$env_Path","User")
    }
  }

$env_path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine") `
          + ';' + [environment]::GetEnvironmentvariable("Path","process")

$env_path_array=$env_path.split(';') | Sort-Object -unique

$env:path="C:\bin;";

Foreach ($item in $env_path_array)
{
  if($env:path.split(';').indexof($item) -eq -1){
    $env:path+="${item};"
  }
}

}
