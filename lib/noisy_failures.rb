module DataMapper
  module Resource
    alias_method :save?, :save
    alias_method :destroy?, :destroy

    def save
      unless self.save?
        raise "#{self.class}: #{self.errors.map { |e| e.join("\n") }.join("\n---\n")}"
      end
    end

    def destroy
      unless self.destroy?
        raise "#{self.class}: Unable to destroy, probably due to associated records."
      end
    end

    def update?(*args)
      self.update(*args)
      true
    rescue => e
      false
    end
  end
end
