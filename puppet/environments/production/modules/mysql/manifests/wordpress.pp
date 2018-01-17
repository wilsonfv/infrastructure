class mysql::wordpress () {
    exec { 'create_wp_db':
        command => '/usr/bin/mysql -u root < /package/mysql/create_wordpress_db.sql',
        onlyif => '/usr/bin/test `mysql -u root -e "show databases;" | grep wordpress | wc -l` -eq 0',
        require => Service['mysqld'],
    }
}