require 'active_record'

class Serie < ActiveRecord::Base
  belongs_to :movie
end
