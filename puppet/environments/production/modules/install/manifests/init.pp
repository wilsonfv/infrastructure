define install (
    $package,
    $ensure  = 'running',
) {
    case $title {
        'nginx': {
            install::yum { 'nginx': package => $package}

            include config::nginx

            service { 'nginx':
                name    => 'nginx',
                ensure  => $ensure,
                require => Class["config::nginx"],
                subscribe => Exec['chown_wp'],
            }
        }

        'php': {
            install::yum { 'php': package => $package}

            include config::php
        }

        'php-fpm': {
            install::yum { 'php-fpm': package => $package}

            service { 'php-fpm':
                name    => 'php-fpm',
                ensure  => $ensure,
                require => [Install::Yum['php-fpm'], Install::Yum['php'], Install::Yum['php-mysql'], Install::Yum['php-gd']],
                subscribe => Exec['chown_wp'],
            }
        }

        'php-mysql': {
            install::yum { 'php-mysql': package => $package}
        }

        'mysql-community-server': {
            install::yum { 'mysql-community-server': package => $package}

            service { 'mysqld':
                name    => 'mysqld',
                ensure  => $ensure,
                require => Install::Yum['mysql-community-server'],
            }

            include mysql::wordpress

            include wordpress
        }

        'wp-cli': {
            exec { 'wp_cli':
                command => '/usr/bin/chmod +x /package/wordpress/wp-cli.phar; /usr/bin/mv /package/wordpress/wp-cli.phar /usr/bin/wp',
                onlyif => '/usr/bin/test ! -e /usr/bin/wp',
            }
        }

        default: { install::yum { $title: package => $title } }
    }
}