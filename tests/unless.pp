shell_command { 'unless_runs':
  command => '/bin/true',
  unless  => '/bin/false',
}

shell_command { 'unless_doesnt_run':
  command => '/bin/false',
  unless  => '/bin/true',
}

