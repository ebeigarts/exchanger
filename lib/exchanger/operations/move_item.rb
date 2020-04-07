module Exchanger
  # The MoveItem operation is used to move one or more items to a single destination folder.
  #
  # https://docs.microsoft.com/en-us/exchange/client-developer/web-service-reference/moveitem-operation
  class MoveItem < Operation
    class Request < Operation::Request
      attr_accessor :items, :folder_id

      # Reset request options to defaults.
      def reset
        @items = []
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"], "xmlns:t" => NS["t"], "xmlns:xsi" => NS["xsi"], "xmlns:xsd" => NS["xsd"]) do
            xml.send("soap:Body") do
              xml.MoveItem("xmlns" => NS["m"], "xmlns:t" => NS["t"]) do
                xml.ToFolderId do
                  if folder_id.is_a?(Symbol)
                    xml.send("t:DistinguishedFolderId", "Id" => folder_id)
                  else
                    xml.send("t:FolderId", "Id" => folder_id)
                  end
                end
                xml.ItemIds do
                  items.each do |item|
                    xml.send "t:ItemId", {"Id" => item.id, "ChangeKey" => item.change_key}
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
