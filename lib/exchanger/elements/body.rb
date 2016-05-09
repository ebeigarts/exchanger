module Exchanger
  # The Body element represents the body of an item.
  #
  # Body:     https://msdn.microsoft.com/en-us/library/office/jj219983(v=exchg.150).aspx
  # BodyType: https://msdn.microsoft.com/en-us/library/office/aa565622(v=exchg.150).aspx
  class Body < Element
    element :body_type  # "HTML" or "Text" (or "Best" during retrieval only)
    element :is_truncated, type: Boolean

    element :text

    def to_xml(options = {})
      doc = Nokogiri::XML::Document.new
      body_attributes = { "BodyType" => body_type || "Text" }
      body_attributes["IsTruncated"] = is_truncated if is_truncated
      root = doc.create_element(tag_name, body_attributes)
      root << doc.create_text_node(text.to_s)
      root
    end
  end
end
