class HdHomeRun

  def self.scanner tuner_num=0
    Runner.new :scan, "/tuner#{tuner_num}"
  end

  # Create a runner to set a tuner's current channel and program.
  #
  # +tuner_num+: (default: 0) Tuner number
  # +options[:channel]+: (required) Channel selection
  # +options[:program]+: (required) Program (subchannel) selection
  #
  # HdHomeRun.tuner( channel: 1, program: 1 )
  # HdHomeRun.tuner( 1, channel: 1, program: 1 )
  def self.tuner tuner_num=0, options={}
    if tuner_num.is_a?(Hash)
      options = tuner_num
      tuner_num = 0
    end

    channel = options[:channel]
    program = options[:program]
    runner  = Runner.new

    runner.add_cmd :set, "/tuner#{tuner_num}/channel #{channel}"
    runner.add_cmd :set, "/tuner#{tuner_num}/program #{program}"

    runner
  end

  # Create a runner to start streaming video to an IP address.
  #
  # +tuner_num+: (default: 0) Tuner number
  # +ip+: (required) IP address to stream to
  # +port+: (default: 1234) Port to stream to
  #
  # HdHomeRun.streamer( ip: '127.0.0.1' )
  # HdHomeRun.streamer( 0, ip: '127.0.0.1' )
  # HdHomeRun.streamer( 1, ip: '127.0.0.1', port: 1234 )
  def self.streamer tuner_num=0, options={}
    if tuner_num.is_a?(Hash)
      options = tuner_num
      tuner_num = 0
    end

    ip    = options[:ip]
    port  = options[:port] || 1234

    Runner.new( :set, "/tuner#{tuner_num}/target #{ip}:#{port}" )
  end

  # Create a runner to write tuning parameters to the device.
  #
  # +tuner_num+: (default: 0) Tuner number
  # +args+: (required) Hash of +command_name: args_string+ pairs
  #
  # HdHomeRun.setter( 0, channelmap: 'us-bcast' )
  def self.setter tuner_num=0, args={}
    if tuner_num.is_a?(Hash)
      args = tuner_num
      tuner_num = 0
    end

    runner = Runner.new
    args.each do |cmd, arg|
      runner.add_cmd :set, "/tuner#{tuner_num}/#{cmd}", arg.to_s
    end

    runner
  end

  # Create a runner to read tuning parameters from the device.
  #
  # +tuner_num+: (default: 0) Tuner number
  # +item+: (required) Item name, symbol or string
  #
  # HdHomeRun.getter( :channelmap )
  # HdHomeRun.getter( 0, :channelmap )
  def self.getter tuner_num=0, item
    if tuner_num.is_a?(Hash)
      item = tuner_num
      tuner_num = 0
    end

    Runner.new :get, "/tuner#{tuner_num}/#{item}"
  end

end