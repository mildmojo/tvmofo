require 'test_helper'

class HdHomeRunTest < ActiveSupport::TestCase
  test 'should return a runner for scanning' do
    runner = HdHomeRun.scanner
    assert runner.respond_to?( :to_cmd )
    assert runner.respond_to?( :run )
  end

  test 'scanner should generate scan command' do
    runner = HdHomeRun.scanner
    assert_equal hd( :scan, '/tuner0' ), runner.to_cmd
    runner = HdHomeRun.scanner(1)
    assert_equal hd( :scan, '/tuner1' ), runner.to_cmd
  end

  test 'tuner should generate tune commands' do
    cmd1 = hd( :set, '/tuner0/channel auto:1' )
    cmd2 = hd( :set, '/tuner0/program 2' )
    runner = HdHomeRun.tuner( 0, channel: 1, program: 2 )
    assert_equal [ cmd1, cmd2 ], runner.to_cmd
  end

  test 'streamer should generate streaming commands' do
    cmd = hd( :set, '/tuner0/target 127.0.0.1:1234' )
    runner = HdHomeRun.streamer( 0, ip: '127.0.0.1', port: 1234 )
    assert_equal cmd, runner.to_cmd
  end

  test 'setter should generate commands to set channel map' do
    cmd = hd( :set, '/tuner0/channelmap us-bcast' )
    runner = HdHomeRun.setter( 0, channelmap: 'us-bcast' )
    assert_equal cmd, runner.to_cmd
  end

  ##############################################################################
  # These tests all run against an actual HDHomeRun device over the network.
  # They each sleep for a second upon completion to allow the device to recover,
  # lest it return "ERROR: resource locked".
  #
  # Invoke these tests with 'rake test:network'.
  #
  if ENV['TESTS_USE_LIVE_NETWORK']
    include Timeout

    test 'scanner should scan' do
      scanner = HdHomeRun.scanner(0)
      assert_run_match /SCANNING/, scanner
      sleep 1
    end

    test 'tuner should tune' do
      tuner = HdHomeRun.tuner( 0, channel: 5, program: 1 )
      timeout(5) do
        assert_equal "\n", tuner.run
      end
      sleep 1
    end

    test 'streamer should stream' do
      streamer = HdHomeRun.streamer( ip: '127.0.0.1' )
      timeout(5) do
        assert_equal '', streamer.run
      end
      sleep 1
    end

    test 'setter should set' do
      setter = HdHomeRun.setter( channelmap: 'us-bcast' )
      timeout(5) do
        assert_equal '', setter.run
      end
      sleep 1
    end

    test 'getter should get' do
      getter = HdHomeRun.setter( :channelmap )
      timeout(5) do
        assert_equal '', getter.run
      end
      sleep 1
    end

  end # if ENV['TESTS_USE_LIVE_NETWORK']

  ##############################################################################
  private
  ##############################################################################

  def hd cmd, args
    "hdhomerun_config #{device_id} #{cmd} #{args}"
  end

  def device_id
    @device_id ||= Rails.application.config.homerun_device_id
  end

  def assert_run_match pattern, runner
    matched = false

    timeout(10) do
      runner.run do |io|
        while line = io.gets
          if matched = line.match( pattern )
            Process.kill 'INT', io.pid
            break
          end
        end
      end
    end

    return matched
  rescue Timeout::Error
    return false
  end

end
