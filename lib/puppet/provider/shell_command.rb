Puppet::Type.type(:shell_command).provide :shell_command do
  include Puppet::Util::Execution
  
  desc 'This provider is a parent for platform specific providers. It is
  responsible for defining the logic used, while children will manage actual
  execution. Different operating systems require different mechanisms for
  launching arbitrary commands and those must be implented by child providers
  with the `execute` method.'

  # This is likely the most confusing method. A shell_command exists if it
  # does not need to be executed by the definition of this type. This way,
  # all tests are done by the provider
  def execution

    unless_allow = true
    refreshonly_allow = true
    creates_allow = true

    # test creates
    creates_allow = ! FileTest.exists?(resource[:creates]) if resource[:creates] != :undef

    # test refreshonly (oh boy...)
    # Do some kinda funky shit ready the catalog maybe?
    # call it true for now as a placeholder

    # test unless
    if resource[:unless] != :undef
      begin
        unless_retval = execute resource[:unless]
      rescue Puppet::ExecutionFailure => e
        Puppet.warning e.message
        unless_allow = true
      end
    end

    # test onlyif
    onlyif_allow = execute resource[:onlyif] if resource[:onlyif] != :undef
    
    # the system is in a state requiring the command's execution if all of
    # these checks pass. if one fails, the effects of the command already
    # exist on the system
    if (unless_allow and onlyif_allow and refreshonly_allow and creates_allow)
      return :not_executed
    else
      return :executed
    end

  end

  def execution= *arg
    execute resource[:command]
  end

end
