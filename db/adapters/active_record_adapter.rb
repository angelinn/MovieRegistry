module DataAccess
  class ActiveRecordAdapter
    extend self

    def find(klass, *args)
      klass.find_by(*args)
    end

    def all(klass)
      klass.all
    end

    def where(klass, *args)
      klass.where(*args)
    end

    def create(klass, *args)
      klass.create(*args)
    end

    def update(entity)
      entity.save
    end

    def delete(entity)
      entity.destroy
    end
end
