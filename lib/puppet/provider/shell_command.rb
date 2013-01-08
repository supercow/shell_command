Puppet::Type.type(:shell_command).provide(:shell_command) do
  include Puppet::Util::Execution

  desc 'This provider is a parent for platform specific providers. It is
  responsible for defining the logic used, while children will manage actual
  execution. Different operating systems require different mechanisms for
  launching arbitrary commands and those must be implented by child providers
  with the `execute` method.'

  # This is likely the most confusing method. A shell_command exists if it
  # does not need to be executed by the definition of this type. This way,
  # all tests are done by the provider
  def exists?
    # TODO: find a way to be ensurable but make ensure read-only
    # if ensure => absent, we don't want to do anything
    # hopefully some smartass doesn't try it
    return false if !resource[:ensure]

    unless_allow = true
    onlyif_allow = true
    refreshonly_allow = true
    creates_allow = true

    # test creates
    creates_allow = ! FileTest.exists(resource[:creates]) if resource[:creates] != nil

    # test refreshonly (oh boy...)
    # Do some kinda funky shit ready the catalog maybe?
    # call it true for now as a placeholder

    # test unless
    if !resource[:unless].nil? # pass if unset
      case resource[:noop_test] #and is_noop_mode TODO
      when :will_run
        unless_allow = true
      when :wont_run
        unless_allow = false
      when :test
        retval = execute resource[:unless]
        if retval == 0 #TODO get a way to test for more than just 0
          unless_allow = false
        else
          unless_allow = true
        end
      end
    end

    # test onlyif
    if !resource[:onlyif].nil? # pass if unset
      case resource[:noop_test] #and is_noop_mode TODO
      when :will_run
        onlyif_allow = true
      when :wont_run
        onlyif_allow = false
      when :test
        retval = execute resource[:onlyif]
        if retval == 0 #TODO get a way to test for more than just 0
          onlyif_allow = true
        else
          onlyif_allow = false
        end
      end
    end

    # the system is in a state requiring the command's execution if all of
    # these checks pass. if one fails, the effects of the command already
    # exist on the system
    !(unless_allow and onlyif_allow and refreshonly_allow and creates_allow)

  end

  def create
    execute resource[:name]
  end

end
