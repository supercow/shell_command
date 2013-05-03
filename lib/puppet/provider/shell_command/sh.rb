require 'puppet/provider/shell_command'

Puppet::Type.type(:shell_command).provide(:sh, :parent => Puppet::Provider::Shell_command) do
  confine :feature => :posix
  confine :true    => File.exists?('/bin/sh')

  defaultfor :feature => :posix

  commands :sh => '/bin/sh -c'

  # how do I get the return code?
  def execute(command)
    begin
      sh(command)
    rescue Puppet::ExecutionFailure => e
      raise e
    end

  end
end

