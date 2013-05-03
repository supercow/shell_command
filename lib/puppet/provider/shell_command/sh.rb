require 'puppet/provider/shell_command'

Puppet::Type.type(:shell_command).provide(:sh, :parent => Puppet::Provider::Shell_command) do
  confine :feature => :posix
  confine :true    => File.exists?('/bin/sh')

  defaultfor :feature => :posix

  commands :sh => '/bin/sh'

  # how do I get the return code?
  def execute(command)
    begin
      sh_c(command)
    rescue Puppet::ExecutionFailure => e
      raise e
    end

  end

  private
  def sh_c(args*)
    sh('-c',args*)
  end
end

