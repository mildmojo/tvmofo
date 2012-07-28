class ChannelScanner
  # DelayedJobify a channel scan
  def scan tuner=0
    scanner = HdHomeRun.scanner( tuner )
    scanner.run do |pipe|
      while line = pipe.gets
        line.chomp!
        case line
          when /^SCANNING/
            frequency, number = line.match(/: (\d+).*:(\d+)/).captures
          when /^LOCK/
            quality = line.match(/snq=(\d+)/).captures.first
          when /^PROGRAM/
            _, program, number_human, *name = line.delete(':').split(' ')
            name = name.join(' ')
            channel = Channel.where( number:      number,
                                     program:     program,
                                     channelmap:  'auto' ).first_or_create!
            channel.update_attributes!( name:         name,
                                        number_human: number_human,
                                        frequency:    frequency.to_i,
                                        quality:      quality )
            Rails.logger.debug "Found channel: #{channel.inspect}"
        end # case line
      end # while line
    end # scanner.run
  end # scan
  handle_asynchronously :scan


end