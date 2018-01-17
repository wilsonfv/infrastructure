node default {
    $projectName = lookup('project::name')

    accounts::user { "$projectName":
        sshkeys => [file("/opt/$projectName/script/master_ssh.key")],
    }

    install { 'createrepo': package => 'createrepo' }
    install { 'nginx': package => 'nginx-1.10.2' }
    install { 'php': package => 'php-5.4.16' }
    install { 'php-fpm': package => 'php-fpm-5.4.16' }
    install { 'php-mysql': package => 'php-mysql-5.4.16' }
    install { 'php-gd': package => 'php-gd' }
    install { 'mysql-community-server': package => 'mysql-community-server-5.6.37' }
    install { 'wp-cli': package => 'wp-cli' }
}