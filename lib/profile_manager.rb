require_relative '../config/environment'

module Profile
  class Manager
    def self.change_name(old_name, new_name)
      user = UserRepository.find(name: old_name)
      user.name = new_name
      UserRepository.update(user)
    end
  end
end
