class TvTuner

  class NoStreamTargetError < StandardError ; end

  def initialize tuner=nil
    @tuner = tuner || 0
  end

  def tune chan
    unless stream_target = Device.where(is_stream_target: true).first
      raise NoStreamTargetError, 'No device is marked as a video streaming target.'
    end
    HdHomeRun.tuner( @tuner, channel: chan.number, program: chan.program ).run
    HdHomeRun.streamer( @tuner, ip: stream_target.address, port: stream_target.port ).run
  end

  def channel
    channelmap, channel_num = HdHomeRun.getter( @tuner, :channel ).run.split(':')
    program = HdHomeRun.getter( @tuner, :program ).run
    Channel.where(number: channel_num, program: program, channelmap: channelmap).first
  end

  def strength
    # ch=auto:39 lock=8vsb ss=88 snq=85 seq=100 bps=19394080 pps=0
    status = Status.new( HdHomeRun.getter( @tuner, :status ).run )
    status.snq.to_i
  end

  ##############################################################################
  private
  ##############################################################################

  class Status
    def initialize status
      keys_and_values = status.split(/\s+/).map { |s| s.split('=') }.flatten
      @fields = HashWithIndifferentAccess[*keys_and_values]
    end

    def method_missing meth_name, *args, &blk
      return @fields[meth_name] if @fields[meth_name]
      super
    end

    def respond_to? meth_name
      return true if @fields[meth_name]
      super
    end
  end
end