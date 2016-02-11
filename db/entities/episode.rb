require 'active_record'

class Episode < ActiveRecord::Base
  has_many :records
end
