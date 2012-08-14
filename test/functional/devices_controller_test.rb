require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  setup do
    @device = devices(:laptop)
  end

  test 'should create device' do
    device_attrs = @device.attributes.slice( *Device.accessible_attributes )
    assert_difference( 'Device.count', 1 ) do
      post :create, device: device_attrs
    end
  end
end
