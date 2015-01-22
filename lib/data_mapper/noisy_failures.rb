module DataMapper
  module Resource
    alias_method :save?, :save
    alias_method :destroy?, :destroy

    def save
      return true if self.save? && self.errors.empty?
      error_message = self.errors.map { |e| "#{self.class}: #{e.join(', ')}" }.join("; ")
      raise SaveFailureError.new(error_message, self)
    end

    def destroy
      return true if self.destroy?
      error_message = "#{self.class}: Unable to destroy, probably due to associated records."
      raise SaveFailureError.new(error_message, self)
    end

    def update?(*args)
      self.update(*args)
      true
    rescue => e
      # This seems like the cleanest way of doing this. #update calls #save internally, so we can't
      # use alias_method because then #update? would call #save, which would raise an exception now
      # that we've done our monkey-patching.
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
