require 'puppet/provider/shell_command'

Puppet::Type.type(:shell_command).provide(:sh, :parent => Puppet::Provider::Shell_command do
  confine :feature => :posix
  confine :true    => File.exists?('/bin/sh')

  defaultfor :feature => :posix

  commands :sh => '/bin/sh -c'

  def execute(command)
    sh(command)
  end
end

