class ChannelsController < InheritedResources::Base
  custom_actions resource: :tune, collection: :status

  respond_to :html, :json

  def tune
    channel = Channel.find( params[:id] )
    TvTuner.new.tune channel

    respond_with( channel ) do |format|
      format.json do
        render json: { status: 'tune_pending' }
      end
      format.html { redirect_to channels_path }
    end
  rescue TvTuner::NoStreamTargetError
    flash[:error] = 'Please edit a device and mark it for TV streaming output.'
    redirect_to devices_path
  end

  def status
    chan = TvTuner.new.channel
    if chan
      body = { status: 'tuned',
               channel_id: chan.id,
               channel_name: chan.number_human }
    else
      body = { status: 'unknown_channel' }
    end

    respond_with( chan ) do |format|
      #format.html { redirect_to channels_path }
      format.json { render json: body }
    end
  end
end
