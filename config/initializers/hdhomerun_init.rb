def discover
  # hdhomerun device 10277FE1 found at 192.168.1.177
  output = `hdhomerun_config discover`.split(/\n/).first
  return nil if output.blank?
  output = output.match(/^hdhomerun device (.*) found.*/)
  return nil if output.blank?
  return output.captures.first
end

device_id = ENV.has_key?('HOMERUN_DEVICE') ? ENV['HOMERUN_DEVICE'] : discover

Rails.application.config.homerun_device_id = device_id
