require 'active_record'

class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  belongs_to :episode
end
