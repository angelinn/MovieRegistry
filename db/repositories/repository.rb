require_relative './base_repository'

module DataAccess
  module Repository
    extend self

    def all
      BaseRepository.all(object_class)
    end

    def find(*args)
      BaseRepository.find(object_class, *args)
    end

    def create(*args)
      BaseRepository.create(*args)
    end

    def where(*args)
      BaseRepository.where(object_class, *args)
    end

    def update(entity)
      BaseRepository.update(entity)
    end

    def delete(record)
      BaseRepository.delete(record)
    end

    private
    def object_class
      @object_class ||= self.to_s.match(/^(.+)Repo/).first.constantize
    end
  end
end
