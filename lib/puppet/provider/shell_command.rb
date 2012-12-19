Puppet::Type.type(:shell_command).provide(:shell_command) do
  include Puppet::Util::Execution

  desc 'This provider is a parent for platform specific providers. It is
  responsible for defining the logic used, while children will manage actual
  execution. Different operating systems require different mechanisms for
  launching arbitrary commands and those must be implented by child providers
  with the `execute` method.'


end
