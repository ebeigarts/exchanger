module Exchanger
  # Abstract class for operations.
  #
  # Exchange Web Services provides many operations that enable you to access
  # information from the Exchanger store.
  # 
  # http://msdn.microsoft.com/en-us/library/bb409286.aspx
  class Operation
    attr_reader :options, :request, :response

    def initialize(options = {})
      @options = options
    end

    # Shortcut for initialize and run.
    def self.run(options = {})
      operation = self.new(options)
      operation.run
    end

    # Returns response
    def run
      @request = self.class::Request.new(options)
      @response = self.class::Response.new(
        Exchanger::Client.new.request(@request.body, @request.headers)
      )
    end

    class Request
      attr_accessor :body, :response

      def initialize(options = {})
        reset
        options.each do |name, value|
          send("#{name}=", value) if respond_to?("#{name}=")
        end
      end

      def reset
      end

      # For a request with class Exchanger::FindItem::Request it will return "FindItem".
      def action
        self.class.name.split("::")[1]
      end

      def headers
        { "SOAPAction" => "http://schemas.microsoft.com/exchange/services/2006/messages/#{action}",
          "Content-Type" => "text/xml; charset=utf-8" }
      end

      def body
        to_xml.to_xml
      end

      def to_xml
        raise "NotImplemented"
      end
    end

    class ResponseError < StandardError
      attr_reader :response_code

      def initialize(message, response_code)
        super message
        @response_code = response_code
      end
    end

    class Response
      attr_reader :status, :body

      def initialize(options = {})
        @status = options[:status]
        @body   = options[:body]
        parse_soap_errors
        parse_response_message
      end

      def to_xml
        @xml ||= Nokogiri::XML(@body)
      end

      def parse_soap_errors
        fault_node = to_xml.xpath(".//faultstring")
        unless fault_node.empty?
          error_msg = fault_node.text
          raise ResponseError.new(error_msg, 0)
        end
      end

      # Checks the ResponseMessage for errors.
      #
      # http://msdn.microsoft.com/en-us/library/aa494164%28EXCHG.80%29.aspx
      # Exhange 2007 Valid Response Messages
      def parse_response_message
        error_node = to_xml.xpath('//m:ResponseMessages/child::*[@ResponseClass="Error"]', NS)
        unless error_node.empty?
          error_msg = error_node.xpath('m:MessageText/text()', NS).to_s
          response_code = error_node.xpath('m:ResponseCode/text()', NS).to_s
          raise ResponseError.new(error_msg, response_code)
        end
      end

      def code
        raise NotImplemented
      end
    end
  end
end
