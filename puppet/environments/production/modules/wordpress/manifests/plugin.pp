define wordpress::plugin (
    $wpPath,
    $pluginPath,
    $pluginName = $title,
    $install = true,
    $activate = true,
) {
    if $install {
        exec { "wp_plugin_install_$pluginName":
            command => "/usr/bin/wp plugin install $pluginPath/$pluginName* --path=$wpPath",
            onlyif => "/usr/bin/test `/usr/bin/wp plugin is-installed $pluginName --path=$wpPath; echo $?` -eq 1",
            require => Exec['install_wp'],
        }
    }

    if $activate {
        exec { "wp_plugin_activate_$pluginName":
            command => "/usr/bin/wp plugin activate $pluginName --path=$wpPath",
            onlyif => "/usr/bin/test `/usr/bin/wp plugin status $pluginName --path=$wpPath  | grep Inactive | wc -l` -eq 1",
        }
    }
}