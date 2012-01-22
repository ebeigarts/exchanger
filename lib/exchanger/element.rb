module Exchanger
  # General purpose element.
  class Element
    include Exchanger::Attributes
    include Exchanger::Dirty
    include Exchanger::Persistence

    class_attribute :elements
    class_attribute :keys
    class_attribute :field_uri_namespace
    class_attribute :identifier_name

    # Exchange expects elements to be in the same order as defined in types.xsd
    self.elements = ActiveSupport::OrderedHash.new
    self.keys = []

    # Define a new child element.
    def self.element(name, options = {})
      options[:field_uri_namespace] ||= self.field_uri_namespace
      self.elements = self.elements.dup
      self.elements[name] = Field.new(name, options)
      create_element_accessors(name)
      add_dirty_methods(name)
    end

    # Defina a new element attribute.
    def self.key(name, options = {})
      self.keys = self.keys.dup
      self.keys << name
      create_element_accessors(name)
      add_dirty_methods(name)
    end

    # Create child element accessors.
    def self.create_element_accessors(name)
      define_method(name) { read_attribute(name) }
      define_method("#{name}=") { |value| write_attribute(name, value) }
      define_method("#{name}?") { read_attribute(name).present? }
    end

    attr_writer :tag_name

    def tag_name
      @tag_name || self.class.name.demodulize
    end

    def initialize(attributes = {})
      @attributes = {}
      self.attributes = attributes
      setup_modifications
    end

    # Performs equality checking on attributes
    def ==(other)
      self.class == other.class &&
      self.attributes == other.attributes
    end

    def errors
      @errors ||= []
    end

    def inspect
      keys = self.class.elements.keys | attributes.keys.map(&:to_sym)
      keys -= [:id, :change_key, self.class.identifier_name]
      attrs = keys.map { |name, field| "#{name}: #{attributes[name.to_s].inspect}" }
      str = "#<#{self.class.name}"
      str << " id: #{id.inspect}, change_key: #{change_key.inspect}" if self.class.identifier_name || self.class.keys.include?(:id)
      str << " #{attrs * ', '}" unless attrs.empty?
      str << ">"
      str
    end

    def self.new_from_xml(xml)
      object = new
      # Keys
      xml.attributes.values.each do |attr|
        name = attr.name.underscore.to_sym
        value = attr.value
        object.write_attribute(name, value)
      end
      # Fields
      xml.children.each do |node|
        name = node.name.underscore.to_sym
        field = elements[name] || Field.new(name)
        value = field.value_from_xml(node)
        object.write_attribute(name, value)
      end
      object.send(:reset_modifications)
      object
    end

    # Builds XML from elements and attributes
    def to_xml(options = {})
      doc = Nokogiri::XML::Document.new
      root = doc.create_element(tag_name)
      self.class.keys.each do |name|
        value = read_attribute(name)
        next if value.blank?
        root[name.to_s.camelize] = value
      end
      self.class.elements.each do |name, field|
        next if options[:only] && !options[:only].include?(name)
        next if field.options[:readonly]
        value = read_attribute(name)
        next if field.type.is_a?(Array) && value.blank?
        next if new_record? && field.type == Identifier
        next if new_record? && value.blank?
        if name == :text
          root << value.to_s
        else
          root << field.to_xml(value)
        end
      end
      root
    end

    # Builds XML Item/Folder change for update operations.
    def to_xml_change
      doc = Nokogiri::XML::Document.new
      root = doc.create_element("#{identifier.tag_name.gsub(/Id$/, '')}Change")
      root << identifier.to_xml
      root << to_xml_updates
      root
    end

    # Builds XML Set/Delete fields for update operations.
    def to_xml_updates
      doc = Nokogiri::XML::Document.new
      root = doc.create_element("Updates")
      self.class.elements.each do |name, field|
        value = read_attribute(name)
        # Create or update existing fields
        if changes.include?(name.to_s)
          field.to_xml_updates(value) do |field_uri_xml, element_xml|
            # Exchange does not like updating to nil, so delete those.
            if element_xml.text.present?
              set_item_field = doc.create_element("SetItemField")
              set_item_field << field_uri_xml
              element_wrapper = doc.create_element(tag_name)
              element_wrapper << element_xml
              set_item_field << element_wrapper
              root << set_item_field
            else
              delete_item_field = doc.create_element("DeleteItemField")
              delete_item_field << field_uri_xml
              root << delete_item_field
            end
          end
        end
        # Delete removed phone numbers, etc
        if changes.include?(name.to_s) && value.is_a?(Array)
          old_values, new_values = changes[name.to_s]
          deleted_values = old_values - new_values
          field.to_xml_updates(deleted_values) do |field_uri_xml, _|
            delete_item_field = doc.create_element("DeleteItemField")
            delete_item_field << field_uri_xml
            root << delete_item_field
          end
        end
      end
      root
    end
  end
end
