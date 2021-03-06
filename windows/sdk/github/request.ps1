Function request($method="GET",$url){
  if(!($env:GITHUB_TOKEN)){
    write-host "
Please set GitHub Token :

$ [environment]::SetEnvironmentvariable('GITHUB_TOKEN', 'XXX', 'User')
" -ForegroundColor Red
    exit

  }

  Invoke-WebRequest -Method $method `
  -Headers @{Authorization="token $env:GITHUB_TOKEN"} `
  $url
}
