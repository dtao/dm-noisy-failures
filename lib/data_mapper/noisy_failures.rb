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

    original_included_method = nil
    if self.respond_to?(:included)
      original_included_method = self.instance_method(:included)
    end

    def self.included(base)
      original_included_method.bind(self).call(base) unless original_included_method.nil?

      def base.create?(*args)
        self.create(*args)
      rescue => e
        nil
      end
    end

    # If any library authors have overridden this, we're screwed.
    # TODO: Figure out if it's possible to detect that case.
    original_include_method = Class.instance_method(:include?)

    # TODO: Maybe look into not just duplicating the above code here?
    ObjectSpace.each_object(Class).each do |existing_class|
      if original_include_method.bind(existing_class).call(Resource)
        def existing_class.create?(*args)
          self.create(*args)
        rescue => e
          nil
        end
      end
    end
  end
end
