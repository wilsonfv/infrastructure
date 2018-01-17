class config::php () {

    exec { 'php.ini':
        command => '/usr/bin/sed -i -e "s/;     session.save_path = \"N;\/path\"/;     session.save_path = \"\/var\/lib\/php\/session\"/g" /etc/php.ini',
        onlyif  => '/usr/bin/test `grep -e ";     session.save_path = \"N;\/path\"" /etc/php.ini | wc -l` -eq 1',
        require => Install::Yum['php'],
    }

    exec { 'chown_nginx':
        command => '/usr/bin/chown -R nginx:nginx /var/lib/php/session',
        onlyif  => '/usr/bin/test `ls -ld /var/lib/php/session | awk \'{print $3}\'` != nginx',
        require => Install::Yum['php'],
    }
}