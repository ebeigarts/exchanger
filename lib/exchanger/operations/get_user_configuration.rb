module Exchanger
  # The GetUserConfiguration operation gets a user configuration object from a folder.
  #
  # https://msdn.microsoft.com/en-us/library/office/dd899439(v=exchg.150).aspx
  class GetUserConfiguration < Operation
    class Request < Operation::Request
      attr_accessor :folder_id, :user_configuration_name

      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.send("soap:Envelope", "xmlns:soap" => NS["soap"]) do
            xml.send("soap:Body") do
              xml.GetUserConfiguration("xmlns" => NS["m"], "xmlns:t" => NS["t"]) do
                xml.send("UserConfigurationName", "Name" => user_configuration_name) do
                  xml.send("t:FolderId", "Id" => folder_id)
                end
                xml.send "UserConfigurationProperties", "All"
              end
            end
          end
        end
      end
    end

    class Response < Operation::Response
      def configuration
        node = to_xml.at_xpath(".//m:UserConfiguration", NS)
        item_klass = Exchanger.const_get(node.name)
        item_klass.new_from_xml(node)
      end
    end
  end
end
