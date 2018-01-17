class wordpress::install_all_plugins (
    $wpPath,
    $pluginPath = '/package/wordpress',
) {
    wordpress::plugin { 'updraftplus':
        wpPath => $wpPath,
        pluginPath => $pluginPath,
        install => true,
        activate => true,
    }
}