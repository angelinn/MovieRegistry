require 'active_record'

class Movie < ActiveRecord::Base
  belongs_to :user
  has_many :episodes
end
