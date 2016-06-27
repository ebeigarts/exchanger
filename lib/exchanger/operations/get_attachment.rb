module Exchanger
  # The GetAttachment element is the root element in a request to get an attachment from the Exchange store.
  #
  # https://msdn.microsoft.com/en-us/library/office/aa564204(v=exchg.150).aspx
  class GetAttachment < Operation
    class Request < Operation::Request
      attr_accessor :attachment_ids, :base_shape

      # Reset request options to defaults.
      def reset
        @attachment_ids = []
        @base_shape = :all_properties
      end

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"]) do
            xml.send("soap:Body") do
              xml.GetAttachment("xmlns" => NS["m"], "xmlns:t" => NS["t"]) do
                xml.AttachmentShape do
                  xml.send "t:BaseShape", base_shape.to_s.camelize
                end
                xml.AttachmentIds do
                  attachment_ids.each do |attachment_id|
                    xml.send("t:AttachmentId", "Id" => attachment_id)
                  end
                end
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def attachments
        to_xml.xpath(".//m:Attachments", NS).children.map do |node|
          attachment_klass = Exchanger.const_get(node.name)
          attachment_klass.new_from_xml(node)
        end
      end
    end
  end
end
