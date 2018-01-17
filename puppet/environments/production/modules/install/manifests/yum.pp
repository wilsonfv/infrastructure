define install::yum (
    $package,
    $installFrom = lookup('package::install'),
) {

    if $installFrom != 'local' {
        $disableLocalRepoOption = '--disablerepo=localrepo'
    }
    else {
        $disableLocalRepoOption = ''
    }

    exec { "install_$title":
        command => "/usr/bin/yum install $package -y $disableLocalRepoOption",
        onlyif  => "/usr/bin/test `yum list installed $package | grep 'Installed Packages' | wc -l` -eq 0",
    }
}