module Exchanger
  # The DeleteItem operation deletes items in the Exchanger store.
  # 
  # You can use the DeleteItem operation to delete the following:
  # * Calendar items
  # * E-mail messages
  # * Meeting requests
  # * Tasks
  # * Contacts
  # 
  # http://msdn.microsoft.com/en-us/library/aa580484.aspx
  class DeleteItem < Operation
    class Request < Operation::Request
      attr_accessor :item_ids

      # Reset request options to defaults.
      def reset
        @item_ids = []
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"], "xmlns:t" => NS["t"], "xmlns:xsi" => NS["xsi"], "xmlns:xsd" => NS["xsd"]) do
            xml.send("soap:Body") do
              xml.DeleteItem("xmlns" => NS["m"], "DeleteType" => "HardDelete") do
                xml.ItemIds do
                  item_ids.each do |item_id|
                    xml["t"].ItemId("Id" => item_id)
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
    end
  end
end
