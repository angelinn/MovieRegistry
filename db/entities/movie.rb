require 'active_record'

class Movie < ActiveRecord::Base
  belongs_to :record
end
