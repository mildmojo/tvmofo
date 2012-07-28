class ChannelScanner
  # DelayedJobify a channel scan
  def scan tuner=0
    scanner = HdHomeRun.scanner( tuner )
    scanner.run do |pipe|
      
    end
  end
  handle_asynchronously :scan

  def scan_cmd tuner=0
    HDHomeRun.scan(tuner).to_cmd
  end

end