module Exchanger
  module Attributes
    def attributes=(values = {})
      values.each do |name, value|
        public_send("#{name}=", value)
      end
    end

    # Return the attributes hash with indifferent access.
    def attributes
      @attributes.with_indifferent_access
    end

    # TODO: Add typecasting
    # Read a value from the +Document+ attributes. If the value does not exist
    # it will return nil.
    def read_attribute(name)
      name = name.to_s
      value = @attributes[name]
      accessed(name, value)
    end

    # TODO: Add typecasting
    def write_attribute(name, value)
      name = name.to_s
      modify(name, @attributes[name], value)
    end

    def identifier
      if self.class.identifier_name
        @identifier ||= self.send(self.class.identifier_name)
        @identifier.tag_name = self.class.identifier_name.to_s.camelize if @identifier
        @identifier
      end
    end

    def id
      identifier && identifier.id
    end

    def change_key
      identifier && identifier.change_key
    end

    # Override respond_to? so it responds properly for dynamic attributes
    def respond_to?(name)
      (@attributes && @attributes.has_key?(name.to_s)) || super
    end

    # Used for allowing accessor methods for dynamic attributes
    def method_missing(name, *args)
      attr = name.to_s.sub("=", "")
      return super unless attributes.has_key?(attr)
      if name.to_s.ends_with?("=")
        write_attribute(attr, *args)
      else
        read_attribute(attr)
      end
    end
  end
end
