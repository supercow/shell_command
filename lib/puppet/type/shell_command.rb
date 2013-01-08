Puppet::Type.newtype(:shell_command) do
  desc "A command which must be executed to ensure the state of the system.
        If parameters to describe when the state of the system is compliant
        are omitted (such as unless, onlyif, creates, and refreshonly), the
        user is asserting that the command must be run repeatedly forever, and
        every invocation is necessarily a state change.
  "
  newproperty(:command, :namevar => true) do
   desc "The actual command to execute.  Must either be fully qualified
        or a search path for the command must be provided.  If the command
        succeeds, any output produced will be logged at the instance's
        normal log level (usually `notice`), but if the command fails
        (meaning its return code does not match the specified code) then
        any output is logged at the `err` log level.
    "
    validate do |cmd|
      #if not qualified and path not specified, fail
      #if the path is not valid for the OS, fail
      true
    end
  end

  newparam(:unless) do
    desc 'Test: The successful execution of this command (return code
    0) indicates that the system state is non-compliant and must be corrected
    by executing the `command`.'

    defaultto nil
  end

  newparam(:refreshonly) do
    desc 'Test: If true, the `command` is only necessarily to ensure system
    state if this `shell_command` resource subscribes to or is notified by
    another resource which has been changed in the current puppet run.'

    defaultto :no
    newvalues(:true, :false)
  end

  newparam(:noop_test) do
    desc 'When the resource is being managed in noop mode, it is sometimes
    undesired to actually execute test commands (`unless` and `onlyif`). This
    parameter controls how noop runs will react to the system. Valid values:
      `test`: `unless` and `onlyif` commands will be executed in noop runs
      `will_run`: `unless` commands are assumed to have failed and `onlyif`
        commands are assumed to have succeeded.
      `wont_run`: `unless` commands are assumed to have succeeded, and `onlyif`
        commands are assumed to have failed.
    Note that the setting of this parameter does not cause the `command` to
    actually run in noop mode - only to determine whether or not it would in
    a normal run.'

    defaultto 'dontrun'
    newvalues('test','run','dontrun')
  end

end
