shell_command { '/bin/true': }

shell_command { '/bin/false': }

shell_command { 'refreshed':
  command     => '/bin/true',
  refreshonly => true,
  subscribe   => Shell_command['/bin/true'],
}

shell_command { 'refreshed_and_failed':
  command     => '/bin/false',
  refreshonly => true,
  subscribe   => Shell_command['/bin/false'],
}

shell_command { 'dependency_failed':
  command     => '/bin/false',
  refreshonly => true,
  require     => Shell_command['refreshed_and_failed'],
}

shell_command { 'not_refreshed':
  command     => '/bin/false',
  refreshonly => true,
}
