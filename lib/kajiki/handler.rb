module Kajiki

  module Handler

    # Check if process exists then fail, otherwise clean up.
    # @return [Boolean] `false` if no PID file exists, `true` if it cleaned up.
    def check_existing_pid
      return false unless pid_file_exists?
      pid = read_pid
      fail 'Existing process found.' if pid > 0 && pid_exists?(pid)
      delete_pid
    end

    # Check if process exists.
    # @param pid [Fixnum]
    # @return [Boolean]
    def pid_exists?(pid)
      Process.kill(0, pid)
      return true
    rescue Errno::ESRCH
      return false
    end

    # Check if PID file exists.
    # @return [Boolean]
    def pid_file_exists?
      return false unless @opts[:pid_given]
      File.exists?(@opts[:pid])
    end

    # Write PID to file.
    def write_pid
      IO.write(@opts[:pid], Process.pid) if @opts[:pid_given]
    end

    # Read PID from file.
    # @return [Fixnum, nil] PID; if `0`, it should be ignored.
    def read_pid
      IO.read(@opts[:pid]).to_i if @opts[:pid_given]
    end

    # Delete PID file if it exists.
    # @return [Boolean] `false` if nothing done, `true` if file was deleted.
    def delete_pid
      if @opts[:pid_given] && File.exists?(@opts[:pid])
        File.delete(@opts[:pid]) 
        return true
      end
      return false
    end

    # Change process UID and GID.
    def change_privileges
      Process.egid = @opts[:group] if @opts[:group_given]
      Process.euid = @opts[:user] if @opts[:user_given]
    end

    # Redirect outputs.
    def redirect_outputs
      if @opts[:error_given]
        $stderr.reopen(@opts[:error], 'a') 
        $stderr.sync = true
      end
      if @opts[:log_given]
        $stdout.reopen(@opts[:log], 'a') 
        $stdout.sync = true
      end
    end

    # Trap common signals as default.
    def trap_default_signals
      Signal.trap('INT') do
        puts 'Interrupted. Terminating process...'
        exit
      end
      Signal.trap('HUP') do
        puts 'SIGHUP - Terminating process...'
        exit
      end
      Signal.trap('TERM') do
        puts 'SIGTERM - Terminating process...'
        exit
      end
    end

  end

end
