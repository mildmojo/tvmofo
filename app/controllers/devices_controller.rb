class DevicesController < InheritedResources::Base
  actions :all

  respond_to :html

  def index
    @new_device = Device.new( address: request.remote_ip, port: 1234 )
    super
  end

  # POST /devices
  def create
    create! do |success, failure|
      success.html { redirect_to devices_path, notice: 'Device created.' }
      failure.html { redirect_to new_device_path,
                                 notice: device.errors.full_messages.join("\n") }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to devices_path, notice: 'Device updated.' }
      failure.html { redirect_to new_device_path,
                                 notice: device.errors.full_messages.join("\n") }
    end
  end
end
