require 'active_record'

class Episode < ActiveRecord::Base
  belongs_to :movie
end
