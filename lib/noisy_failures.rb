module DataMapper
  module Resource
    alias_method :save?, :save
    alias_method :destroy?, :destroy

    def save
      unless self.save?
        error_message = self.errors.map { |e| "#{self.class}: #{e.join(', ')}" }.join("\n")
        raise SaveFailureError.new(error_message, self)
      end
    end

    def destroy
      unless self.destroy?
        error_message = "#{self.class}: Unable to destroy, probably due to associated records."
        raise SaveFailureError.new(error_message, self)
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
