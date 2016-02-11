require 'active_record'

class Record < ActiveRecord::Base
  has_one :user
  has_one :movie
  has_one :episode
end
