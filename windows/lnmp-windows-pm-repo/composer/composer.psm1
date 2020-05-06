Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'
$insert_path=$lwpm.path

Function install_after(){

}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  if($isPre){
    $VERSION=$pre_version
  }else{

  }

  $url="https://github.com/composer/composer/releases/download/${VERSION}/composer.phar"
  $filename="composer.phar"
  $unzipDesc="composer"

  _exportPath "$env:ProgramData\ComposerSetup\bin\", `
              "$HOME\AppData\Roaming\Composer\vendor\bin"

  if($(_command composer)){
    $CURRENT_VERSION=(composer --version).split(" ")[2]

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
        return
    }else{
        composer self-update $VERSION
        return
    }
  }

  # 下载原始 zip 文件，若存在则不再进行下载

  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _cleanup ""
  # _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "${PSScriptRoot}\composer"     "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "${PSScriptRoot}\composer.ps1" "$env:ProgramData\ComposerSetup\bin\"
  Copy-item -r -force "composer.phar"                "$env:ProgramData\ComposerSetup\bin\"
  # Start-Process -FilePath $filename -wait
  # _cleanup ""

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "$env:ProgramData\ComposerSetup\bin\", `
              "$HOME\AppData\Roaming\Composer\vendor\bin"

  install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  composer --version
}

Function uninstall($prune=0){
  _sudo "remove-item -r -force $env:ProgramData\ComposerSetup"
  # user data
  if($prune){
    _cleanup "$HOME\AppData\Roaming\Composer"
    _cleanup "$HOME\AppData\Local\Composer"
  }
}
