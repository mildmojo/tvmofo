class Device < ActiveRecord::Base
  attr_accessible :address, :name, :port
end
