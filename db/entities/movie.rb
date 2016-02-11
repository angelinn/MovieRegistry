require 'active_record'

class Movie < ActiveRecord::Base
  has_many :records
end
