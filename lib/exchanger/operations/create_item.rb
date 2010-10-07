module Exchanger
  # The CreateItem operation creates items in the Exchanger store.
  # 
  # You can use the CreateItem operation to create the following:
  # * Calendar items
  # * E-mail messages
  # * Meeting requests
  # * Tasks
  # * Contacts
  # 
  # http://msdn.microsoft.com/en-us/library/aa563797.aspx
  class CreateItem < Operation
    class Request < Operation::Request
      attr_accessor :folder_id, :email_address, :items

      # Reset request options to defaults.
      def reset
        @folder_id = :contacts
        @email_address = nil
        @items = []
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"], "xmlns:t" => NS["t"], "xmlns:xsi" => NS["xsi"], "xmlns:xsd" => NS["xsd"]) do
            xml.send("soap:Body") do
              xml.CreateItem("xmlns" => NS["m"]) do
                xml.SavedItemFolderId do
                  if folder_id.is_a?(Symbol)
                    xml.send("t:DistinguishedFolderId", "Id" => folder_id) do
                      if email_address
                        xml.send("t:Mailbox") do
                          xml.send("t:EmailAddress", email_address)
                        end
                      end
                    end
                  else
                    xml.send("t:FolderId", "Id" => folder_id)
                  end
                end
                xml.Items do
                  items.each do |item|
                    item_xml = item.to_xml
                    item_xml.add_namespace_definition("t", NS["t"])
                    item_xml.namespace = item_xml.namespace_definitions[0]
                    xml << item_xml.to_s
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def item_ids
        to_xml.xpath(".//t:ItemId", NS).map do |node|
          Identifier.new_from_xml(node)
        end
      end
    end
  end
end
