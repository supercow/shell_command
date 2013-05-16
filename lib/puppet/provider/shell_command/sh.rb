require 'puppet/provider/shell_command'
Puppet::Type.type(:shell_command).provide :sh, :parent => :shell_command do
  confine :feature => :posix
  defaultfor :feature => :posix

  commands :sh => 'sh'

  def success
  end

  # how do I get the return code?
  def execute(command)
    sh('-c',command)
  end
end

