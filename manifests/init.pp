class tilde (
  $users,
  $hostname,
  $use_quota = true,
  $addtl_packages = [],
  $newsgroups = [],
  $newspeers = []
) {

  include tilde::packages
  include tilde::mail
  include tilde::skel
  include tilde::irc

  class { 'tilde::nntp':
    hostname => $hostname,
    newsgroups => $newsgroups,
    peers => $newspeers,
  }

  class { 'tilde::webserver':
    hostname => $hostname,
  }

  if ($use_quota) {
    include tilde::quota
  }

  group { 'town':
    ensure => present,
  }

  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

  package { $addtl_packages:
    ensure => present,
  }

  tilde:templatedfile { 'rendered motd':
    template => "${module_name}/motd.erb",
    path => "/etc/motd",
  }

  create_resources(tilde::user, $users)

}
