require 'active_record'

class User < ActiveRecord::Base
  attr_reader :name
end
