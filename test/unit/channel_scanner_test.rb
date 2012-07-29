require 'test_helper'

class ChannelScannerTest < ActiveSupport::TestCase

  setup do
    @scanner = ChannelScanner.new( ENV['TEST_TUNER'] )
  end

  if ENV['TESTS_USE_LIVE_NETWORK']
    test 'should use a delayed job to scan channels and populate channel table' do
      Channel.destroy_all

      # Queue it up
      assert_difference( 'Delayed::Job.count', 1 ) do
        ChannelScanner.new.scan
      end

      # Work it off (MAY TAKE A VERY, VERY LONG TIME)
      puts "\nSCANNING CHANNELS, MAY TAKE SEVERAL MINUTES\n"
      assert_difference( 'Delayed::Job.count', -1 ) do
        Delayed::Worker.new.work_off
      end

      # Make sure we have channels now
      assert Channel.count > 0
    end
  end

end