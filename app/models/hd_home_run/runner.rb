class Runner
  # new( :set, '/tuner0/channelmap us-bcast' )
  # new( :set, '/tuner0/channelmap', 'us-bcast' )
  def initialize cmd=nil, *args
    @device_id = Rails.application.config.homerun_device_id
    @cmds = []

    if cmd
      @cmds << { cmd: cmd.to_s, args: [args].flatten }
    end
  end

  # add_cmd( :set, '/tuner0/channelmap us-bcast' )
  # add_cmd( :set, '/tuner0/channelmap', 'us-bcast' )
  def add_cmd cmd, *args
    @cmds << { cmd: cmd.to_s, args: [args].flatten }
    self
  end

  # Turn the commands into a string or an array of strings.
  def to_cmd
    commands = @cmds.map { |cmd|
      "hdhomerun_config #{@device_id} #{cmd[:cmd]} #{cmd[:args].join(' ')}"
    }
    return commands.length == 1 ? commands.first : commands
  end

  # Fire up the command in a synchronous subprocess.
  # If a block is given, yields for each subcommand with an IO pipe argument.
  # If no block is given, returns STDOUT for all commands joined with newlines.
  def run
    [self.to_cmd].flatten.collect { |cmd|
      if block_given?
        result = yield( IO.popen( cmd ) )
        result.respond_to?( :to_s ) ? result.to_s : ''
      else
        `#{cmd}`
      end
    }.join("\n")
  end
end
