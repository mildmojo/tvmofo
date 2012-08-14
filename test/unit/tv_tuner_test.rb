require 'test_helper'

class TvTunerTest < ActiveSupport::TestCase

  class FakeRunner

  end

  setup do
    @device = devices(:laptop)
    @channel = channels(:channels_001)
    @tuner = TvTuner.new( ENV['TEST_TUNER'] )
  end

  test 'should tune to channel' do
    HdHomeRun.expects( :tuner )
             .with( 0, channel: @channel.number, program: @channel.program )
             .returns( stub( run: '' ) )
    HdHomeRun.expects( :streamer )
             .with( 0, ip: @device.address, port: @device.port )
             .returns( stub( run: '' ) )
    @tuner.tune @channel
  end

  test 'tuner should raise if no stream targets are defined' do
    Device.update_all(is_stream_target: false)
    assert_raises(TvTuner::NoStreamTargetError) do
      @tuner.tune @channel
    end
  end

  test 'should get current channel LIVE' do
    HdHomeRun.expects( :getter ).
              with( 0, :channel ).
              returns( stub( run: ':' ) )
    HdHomeRun.expects( :getter ).
              with( 0, :program ).
              returns( stub( run: '' ) )
    Channel.expects(:where).
            returns( stub( first: @channel ) )
    assert_equal @channel, @tuner.channel
  end

  test 'should get current channel strength LIVE' do
    HdHomeRun.expects( :getter ).
              with( 0, :status ).
              returns( stub( run: 'snq=100' ) )
    strength = @tuner.strength
    assert strength == 100
  end

  if ENV['TESTS_USE_LIVE_NETWORK']
    test 'should tune to channel LIVE' do
      @tuner.tune @channel
      expected_channel = "#{@channel.channelmap}:#{@channel.number}"
      assert_equal expected_channel, HdHomeRun.getter( ENV['TEST_TUNER'] || 0, :channel ).run
    end

    test 'should get current channel LIVE' do
      HdHomeRun.setter( ENV['TEST_TUNER'] || 0, channel: @channel ).run
      assert_equal @channel, @tuner.channel
    end

    test 'should get current channel strength LIVE' do
      HdHomeRun.setter( ENV['TEST_TUNER'] || 0, channel: @channel ).run
      strength = @tuner.strength
      assert strength >= 0 && strength <= 100, 'should be between 0 and 100'
    end
  end
end