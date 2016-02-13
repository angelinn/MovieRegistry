class Repository
  class << self
    def adapter
      @adapter
    end

    def adapter=(adapter)
      @adapter = adapter
    end

    def all(klass)
      adapter.all(klass)
    end

    def find(klass, *args)
      adapter.find(klass, *args)
    end

    def where(klass, *args)
      adapter.where(klass, *args)
    end

    def create(klass, *args)
      adapter.create(klass, *args)
    end

    def update(entity)
      adapter.update(entity)
    end

    def delete(entity)
      adapter.delete(entity)
    end
  end
end
