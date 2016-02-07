require 'active_record'

class Series < ActiveRecord::Base
  attr_reader :title, :year, :episode, :season
end
