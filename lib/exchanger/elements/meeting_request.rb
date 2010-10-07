module Exchanger
  # TODO Almost the same as calendar item
  class MeetingRequest < MeetingMessage
    self.field_uri_namespace = :meeting_request
  end
end
