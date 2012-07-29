class DevicesController < InheritedResources::Controller
  respond_to :html

  # POST /devices
  def create
    create! do |success, failure|
      success.html { respond_with device, notice: 'Device created.' }
      failure.html { redirect_to new_device_path,
                                 notice: device.errors.full_messages.join("\n") }
    end
  end
end
