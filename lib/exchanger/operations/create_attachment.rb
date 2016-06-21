module Exchanger
  # The CreateAttachment element defines a request to create an attachment to an item in the Exchange store.
  #
  # https://msdn.microsoft.com/en-us/library/office/aa565931(v=exchg.150).aspx
  class CreateAttachment < Operation
    class Request < Operation::Request
      attr_accessor :parent_item_id, :attachments

      # Reset request options to defaults.
      def reset
        @parent_item_id = nil
        @attachments = []
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"], "xmlns:t" => NS["t"], "xmlns:xsi" => NS["xsi"], "xmlns:xsd" => NS["xsd"]) do
            xml.send("soap:Body") do
              xml.CreateAttachment("xmlns" => NS["m"]) do
                xml.ParentItemId("Id" => parent_item_id)
                xml.Attachments do
                  attachments.each do |attachment|
                    attachment_xml = attachment.to_xml
                    attachment_xml.add_namespace_definition("t", NS["t"])
                    attachment_xml.namespace = attachment_xml.namespace_definitions[0]
                    xml << attachment_xml.to_s
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def attachment_ids
        to_xml.xpath(".//t:AttachmentId", NS).map do |node|
          Identifier.new_from_xml(node)
        end
      end
    end
  end
end
