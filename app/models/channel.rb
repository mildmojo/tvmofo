class Channel < ActiveRecord::Base

  attr_accessible :channelmap,
                  :description,
                  :name,
                  :frequency,
                  :number,
                  :number_human,
                  :program_link,
                  :program,
                  :quality

end
