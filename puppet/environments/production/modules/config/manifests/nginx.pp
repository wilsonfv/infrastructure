class config::nginx (
    String $owner = 'root',
    String $group = $owner,
    String $mode  = '0644',
) {
    if lookup('project::env') == 'local' {
        $nginxDefaultConf = 'default_local.conf'
    }
    else {
        $nginxDefaultConf = 'default.conf'
    }

    file { '/etc/nginx/conf.d/default.conf':
        ensure  => present,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        source  => "puppet:///modules/config/nginx/$nginxDefaultConf",
        require => Install::Yum['nginx'],
    }

    exec { 'comment_nginx.conf_ipv4_listen':
        command => '/usr/bin/sed -i -e "s/        listen       80 default_server\;/\#       listen       80 default_server\;/" /etc/nginx/nginx.conf',
        onlyif => '/usr/bin/test `grep -E "        listen       80 default_server;" /etc/nginx/nginx.conf | wc -l` -eq 1',
        require => Install::Yum['nginx'],
    }

    exec { 'comment_nginx.conf_ipv6_listen':
        command => '/usr/bin/sed -i -e "s/        listen       \[::\]:80 default_server\;/\#        listen       \[::\]:80 default_server\;/g" /etc/nginx/nginx.conf',
        onlyif => '/usr/bin/test `grep -E "        listen       \[::\]:80 default_server\;" /etc/nginx/nginx.conf | wc -l` -eq 1',
        require => Install::Yum['nginx'],
    }
}