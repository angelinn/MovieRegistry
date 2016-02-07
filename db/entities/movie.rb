require 'active_record'

class Movie < ActiveRecord::Base
  attr_reader :title, :year, :seen_at
end
