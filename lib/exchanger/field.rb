module Exchanger
  class Field
    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def type
      options[:type] || String
    end

    def tag_name
      (options[:name] || name).to_s.camelize
    end

    # Only for arrays
    def sub_field
      if type.is_a?(Array)
        Field.new(name, {
          :type => type[0],
          :field_uri_namespace => field_uri
        })
      end
    end

    def field_uri_namespace
      options[:field_uri_namespace].to_s
    end

    def field_uri
      if name == :text
        field_uri_namespace
      else
        "#{field_uri_namespace}:#{tag_name}"
      end
    end

    # FieldURI or IndexedFieldURI
    # <t:FieldURI FieldURI="item:Sensitivity"/>
    # <t:IndexedFieldURI FieldURI="contacts:EmailAddress" FieldIndex="EmailAddress1"/>
    # 
    # http://msdn.microsoft.com/en-us/library/aa494315.aspx
    # http://msdn.microsoft.com/en-us/library/aa581079.aspx
    def to_xml_field_uri(value)
      doc = Nokogiri::XML::Document.new
      if value.is_a?(Entry)
        doc.create_element("IndexedFieldURI", "FieldURI" => field_uri, "FieldIndex" => value.key)
      else
        doc.create_element("FieldURI", "FieldURI" => field_uri)
      end
    end

    # See Element#to_xml_updates.
    # Yields blocks with FieldURI and Item/Folder/etc changes.
    def to_xml_updates(value)
      return if options[:readonly]
      doc = Nokogiri::XML::Document.new
      if value.is_a?(Array)
        value.each do |sub_value|
          sub_field.to_xml_updates(sub_value) do |field_uri_xml, element_xml|
            element_wrapper = doc.create_element(sub_field.tag_name)
            element_wrapper << element_xml
            yield [
              field_uri_xml,
              element_wrapper
            ]
          end
        end
      elsif value.is_a?(Exchanger::Element)
        value.tag_name = tag_name
        if value.class.elements.keys.include?(:text)
          field = value.class.elements[:text]
          yield [
            field.to_xml_field_uri(value),
            field.to_xml(value)
          ]
        else
          # PhysicalAddress ?
          value.class.elements.each do |name, field|
            yield [
              field.to_xml_field_uri(value),
              field.to_xml(value, :only => [name])
            ]
          end
        end
      else # String, Integer, Boolean, ...
        yield [
          self.to_xml_field_uri(value),
          self.to_xml(value)
        ]
      end
    end

    # Convert Ruby value to XML
    def to_xml(value, options = {})
      if value.is_a?(Exchanger::Element)
        value.tag_name = tag_name
        value.to_xml(options)
      else
        doc = Nokogiri::XML::Document.new
        root = doc.create_element(tag_name)
        case value
        when Array
          value.each do |sub_value|
            root << sub_field.to_xml(sub_value, options)
          end
        when Boolean
          root << doc.create_text_node(value == true)
        when Time
          root << doc.create_text_node(value.xmlschema)
        else # String, Integer, etc
          root << doc.create_text_node(value.to_s)
        end
        root
      end
    end

    # Convert XML to Ruby value
    def value_from_xml(node)
      if type.respond_to?(:new_from_xml)
        type.new_from_xml(node)
      elsif type.is_a?(Array)
        node.children.map do |sub_node|
          sub_field.value_from_xml(sub_node)
        end
      elsif type == Boolean
        node.text == "true"
      elsif type == Integer
        node.text.to_i unless node.text.empty?
      elsif type == Time
        Time.xmlschema(node.text) unless node.text.empty?
      else
        node.text
      end
    end
  end
end
