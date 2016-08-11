module Exchanger
  # The UserConfiguration element defines a single user configuration object.
  #
  # https://msdn.microsoft.com/en-us/library/office/dd899334(v=exchg.150).aspx
  class UserConfiguration < Element
    self.field_uri_namespace = :item
    self.identifier_name = :item_id

    element :user_configuration_name, type: UserConfigurationName
    element :item_id, type: Identifier
    element :dictionary
    element :xml_data
    element :binary_data

    # A category list is a type of configuration data that contains a list of textual labels (or categories)
    # with associated data, such as color. Other attributes of a category include a shortcut key that can be
    # used to apply a category, a usage counter, the last time the category was applied or used by the user, and a GUID.
    #
    # https://msdn.microsoft.com/en-us/library/ee203806(v=exchg.80).aspx
    def category_list
      return unless user_configuration_name.name == "CategoryList"
      xml_to_category_list
    end

    private

      def xml_to_category_list
        xml = Nokogiri::XML(Base64.decode64(xml_data))
        ns = xml.namespaces.keys.first
        xml.xpath(".//#{ns}:category").map { |node| Category.new_from_xml(node) }
      end
  end
end
