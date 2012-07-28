class Channel < ActiveRecord::Base
  attr_accessible :channelmap,
                  :description,
                  :name,
                  :number,
                  :program_link,
                  :subprogram

end
