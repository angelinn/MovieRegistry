require_relative 'repository'

module Repository::Concrete
  extend self

  def all
    Repository.all(object_class)
  end

  def find(*args)
    Repository.find(object_class, *args)
  end

  def create(*args)
    Repository.create(object_class, *args)
  end

  def where(*args)
    Repository.where(object_class, *args)
  end

  def update(entity)
    Repository.update(entity)
  end

  def delete(record)
    Repository.delete(record)
  end

  private
  def object_class
    @object_class ||= self.to_s.match(/^(.+)Repo/)[1].constantize
  end
end
