require "singleton"
require "delegate"
require "base64"
require 'kconv' # Need for rubyntlm on Ruby 1.9
require 'tzinfo'

require "active_support"
require "active_support/core_ext"
require "nokogiri"
require "httpclient"
require "net/ntlm"

require "exchanger/version"
require "exchanger/config"
require "exchanger/client"
require "exchanger/boolean"
require "exchanger/field"
require "exchanger/dirty"
require "exchanger/attributes"
require "exchanger/persistence"

# Elements
require "exchanger/element"
require "exchanger/elements/identifier"
require "exchanger/elements/mailbox"
require "exchanger/elements/single_recipient"
require "exchanger/elements/attendee"
require "exchanger/elements/complete_name"
require "exchanger/elements/calendar_view"
require "exchanger/elements/body"
# Entry elements
require "exchanger/elements/entry"
require "exchanger/elements/email_address"
require "exchanger/elements/phone_number"
require "exchanger/elements/physical_address"
require "exchanger/elements/im_address"
# Folder elements
require "exchanger/elements/base_folder"
require "exchanger/elements/folder"
require "exchanger/elements/calendar_folder"
require "exchanger/elements/contacts_folder"
require "exchanger/elements/tasks_folder"
require "exchanger/elements/search_folder"
require "exchanger/elements/user_configuration_name"
require "exchanger/elements/user_configuration"
# Item elements
require "exchanger/elements/category_string"
require "exchanger/elements/category_color"
require "exchanger/elements/category"
require "exchanger/elements/attachment"
require "exchanger/elements/item"
require "exchanger/elements/message"
require "exchanger/elements/calendar_item"
require "exchanger/elements/contact"
require "exchanger/elements/meeting_message"
require "exchanger/elements/meeting_request"
require "exchanger/elements/meeting_response"
require "exchanger/elements/meeting_cancellation"
require "exchanger/elements/task"
require "exchanger/elements/distribution_list"
require "exchanger/elements/calendar_event_details"
require "exchanger/elements/calendar_event"
require "exchanger/elements/item_attachment"
require "exchanger/elements/file_attachment"

# Operations
require "exchanger/operation"
require "exchanger/operations/get_folder"
require "exchanger/operations/find_folder"
require "exchanger/operations/get_item"
require "exchanger/operations/find_item"
require "exchanger/operations/create_item"
require "exchanger/operations/update_item"
require "exchanger/operations/delete_item"
require "exchanger/operations/resolve_names"
require "exchanger/operations/expand_dl"
require "exchanger/operations/get_user_availability"
require "exchanger/operations/get_attachment"
require "exchanger/operations/create_attachment"
require "exchanger/operations/delete_attachment"
require "exchanger/operations/get_user_configuration"
require "exchanger/operations/move_item"

module Exchanger
  NS = {
    "xsi"  => "http://www.w3.org/2001/XMLSchema-instance",
    "xsd"  => "http://www.w3.org/2001/XMLSchema",
    "soap" => "http://schemas.xmlsoap.org/soap/envelope/",
    "m"    => "http://schemas.microsoft.com/exchange/services/2006/messages",
    "t"    => "http://schemas.microsoft.com/exchange/services/2006/types"
  }

  class << self
    # The Exchanger +Config+ singleton instance.
    def configure
      config = Config.instance
      block_given? ? yield(config) : config
    end

    alias :config :configure
  end
end
