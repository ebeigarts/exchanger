module Exchanger
  # The UpdateItem operation is used to modify the properties of an existing item in the Exchanger store.
  #
  # http://msdn.microsoft.com/en-us/library/aa581084.aspx
  # http://msdn.microsoft.com/en-us/library/aa579673.aspx
  class UpdateItem < Operation
    class Request < Operation::Request
      attr_accessor :items, :send_meeting_invitations_or_cancellations

      # Reset request options to defaults.
      def reset
        @items = []
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"], "xmlns:t" => NS["t"], "xmlns:xsi" => NS["xsi"], "xmlns:xsd" => NS["xsd"]) do
            xml.send("soap:Body") do
              xml.UpdateItem(update_item_attributes) do
                xml.ItemChanges do
                  items.each do |item|
                    item_change = item.to_xml_change
                    item_change.add_namespace_definition("t", NS["t"])
                    item_change.namespace = item_change.namespace_definitions[0]
                    xml << item_change.to_s
                  end
                end
              end
            end
          end
        end
      end

      private

        def update_item_attributes
          update_item_attributes = { "xmlns" => NS["m"], "ConflictResolution" => "AlwaysOverwrite" }
          update_item_attributes["SendMeetingInvitationsOrCancellations"] = send_meeting_invitations_or_cancellations if send_meeting_invitations_or_cancellations
          update_item_attributes
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
