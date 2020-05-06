function getToken($image,
                  $action="pull",
                  $tokenSever="https://auth.docker.io/token",
                  $tokenService="registry.docker.io",
                  $cache=$false){

  . $PSScriptRoot/../cache/cache.ps1

  $token_file=getCachePath ".token@$($image.replace('/','@'))@${action}@$($tokenService.replace(':','-'))"

  Write-Host "==> Token File is $token_file"

  if($cache -and (Test-Path $token_file)){
    $token = Get-Content $token_file -raw -Encoding utf8

    return $token
  }

if(!$env:DOCKER_USERNAME){
  Write-Warning "ENV var DOCKER_USERNAME not set"
  $DOCKER_USERNAME='usernamekhs1994666'
}else{
  $DOCKER_USERNAME=$env:DOCKER_USERNAME
}

if(!$env:DOCKER_PASSWORD){
  Write-Warning "ENV var DOCKER_PASSWORD not set"
  $DOCKER_PASSWORD='passwordkhs1994666'
}else{
  $DOCKER_PASSWORD=$env:DOCKER_PASSWORD
}

$user = $env:DOCKER_USERNAME
$pass = $env:DOCKER_PASSWORD

if(!$user){$user='user'}
if(!$pass){$pass='pass'}

$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($user, $secpasswd)

# $credential=Get-Credential

try{
$result = Invoke-WebRequest -Authentication Basic -credential $Credential `
"${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}" `
-UserAgent "Docker-Client/19.03.5 (Windows)"
}catch{
  write-host $_.Exception.ToString()

  return $null
}

$token = (ConvertFrom-Json $result.Content).token

if(!$token){
  $token = (ConvertFrom-Json $result.Content).access_token
}

Set-Content $token_file $token

return $token
}
