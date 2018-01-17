class wordpress (
    $nginxPath    = '/usr/share/nginx/html',
    $wpPath       = "$nginxPath/blog",
    $wpDbName     = 'wordpress',
    $wpDbUser     = 'wpuser',
    $wpDbPass     = 'wppassword',
    $wpDbHost     = 'localhost',
    $wpUrl        = lookup('wordpress::url'),
    $wpTitle      = lookup('wordpress::title'),
    $wpAdmin      = lookup('wordpress::admin'),
    $wpAdminPass  = lookup('wordpress::adminPass'),
    $wpAdminEmail = lookup('wordpress::adminEmail'),
) {
    exec { 'untar_wp':
        command => "/usr/bin/rm -f $nginxPath/index.html;
                    /usr/bin/tar -zxf /package/wordpress/wordpress*tar.gz -C $nginxPath;
                    /usr/bin/mv $nginxPath/wordpress $wpPath;",
        onlyif  => "/usr/bin/test ! -e $wpPath",
        require => [Install::Yum['nginx'], Install::Yum['mysql-community-server']]
    }

    exec { 'config_wp':
        command => "/usr/bin/cp $wpPath/wp-config-sample.php $wpPath/wp-config.php",
        onlyif  => "/usr/bin/test ! -e $wpPath/wp-config.php",
        require => Exec['untar_wp'],
    }

    exec { 'update_wp_config_dbname':
        command => "/usr/bin/sed -i -e \"s/database_name_here/$wpDbName/g\" $wpPath/wp-config.php",
        onlyif => "/usr/bin/test `grep 'database_name_here' $wpPath/wp-config.php | wc -l` -eq 1",
        require => Exec['config_wp'],
    }

    exec { 'update_wp_config_dbuser':
        command => "/usr/bin/sed -i -e \"s/username_here/$wpDbUser/g\" $wpPath/wp-config.php",
        onlyif => "/usr/bin/test `grep 'username_here' $wpPath/wp-config.php | wc -l` -eq 1",
        require => Exec['config_wp'],
    }

    exec { 'update_wp_config_dbpass':
        command => "/usr/bin/sed -i -e \"s/password_here/$wpDbPass/g\" $wpPath/wp-config.php",
        onlyif => "/usr/bin/test `grep 'password_here' $wpPath/wp-config.php | wc -l` -eq 1",
        require => Exec['config_wp'],
    }

    exec { 'install_wp':
        command => "/usr/bin/wp core install --path=$wpPath --url=$wpUrl --title=$wpTitle --admin_user=$wpAdmin --admin_password=$wpAdminPass --admin_email=$wpAdminEmail",
        onlyif  => "/usr/bin/test `/usr/bin/wp core is-installed --path=$wpPath; echo $?` -eq 1",
        require => [Exec['update_wp_config_dbname'],
                    Exec['update_wp_config_dbuser'],
                    Exec['update_wp_config_dbpass'],
                    Install['wp-cli']],
    }

    exec { 'chown_wp':
        command => "/usr/bin/chown -R apache:apache $wpPath",
        onlyif => "/usr/bin/test `/usr/bin/find $wpPath ! -user apache | wc -l` -ne 0",
        require => Exec['install_wp'],
    }

    exec { 'update_wp_siteurl':
        command => "/usr/bin/wp option update siteurl 'http://$wpUrl' --path=$wpPath",
        onlyif => "/usr/bin/test `/usr/bin/wp option get siteurl --path=$wpPath | grep '$wpUrl' | wc -l` -eq 0",
        require => Exec['install_wp'],
    }

    exec { 'update_wp_home':
        command => "/usr/bin/wp option update home 'http://$wpUrl' --path=$wpPath",
        onlyif => "/usr/bin/test `/usr/bin/wp option get home --path=$wpPath | grep '$wpUrl' | wc -l` -eq 0",
        require => Exec['install_wp'],
    }

    class { 'wordpress::install_all_plugins':
        wpPath => $wpPath,
    }

    exec { 'updraft':
        command => "/usr/bin/mkdir $wpPath/wp-content/updraft; /usr/bin/chmod 0777 $wpPath/wp-content/updraft",
        onlyif => "/usr/bin/test ! -d $wpPath/wp-content/updraft",
        require => Exec['wp_plugin_activate_updraftplus'],
    }
}