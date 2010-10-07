module Exchanger
  class MeetingMessage < Item
    self.field_uri_namespace = :meeting

    element :associated_calendar_item_id, :type => Identifier
    element :is_delegated, :type => Boolean
    element :is_out_of_date, :type => Boolean
    element :has_been_processed, :type => Boolean
    # Meeting response related properties
    element :response_type # Unknown, Organizer, Tentative, Accept, Decline, NoResponseReceived
    # iCalendar properties
    element :uid, :name => "UID"
    element :recurrence_id, :type => Time
    element :date_time_stamp, :type => Time
  end
end
