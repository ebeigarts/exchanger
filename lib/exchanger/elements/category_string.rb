module Exchanger
  # The CategoryString is the subelement for the Categories element in the CreateItem, GetItem, and UpdateItem operations.
  #
  # https://msdn.microsoft.com/en-us/library/aa565683(v=exchg.150).aspx
  class CategoryString < Element
    element :text

    def tag_name
      "String"
    end

    # For backwards compatibility in GetItem requests, we will continue to return a String instead of an Exchanger::CategoryString.
    def self.new_from_xml(xml)
      super.text
    end
  end
end
