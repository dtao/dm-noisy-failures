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

    @@original_included_method = self.method(:included) rescue nil

    def self.included(base)
      @@original_included_method.call(base) unless @@original_included_method.nil?

      def base.create?(*args)
        self.create(*args)
      rescue => e
        nil
      end
    end
  end
end
