module Exchanger
  # The CalendarItem element represents an Exchanger calendar item.
  #
  # http://msdn.microsoft.com/en-us/library/aa564765.aspx
  class CalendarItem < Item
    self.field_uri_namespace = :calendar

    # iCalendar properties
    element :uid, :name => "UID"
    element :recurrence_id, :type => Time
    element :date_time_stamp, :type => Time
    # Single and Occurrence only
    element :start, :type => Time
    element :end, :type => Time
    # Occurrence only
    element :original_start, :type => Time
    # Other properties
    element :is_all_day_event, :type => Boolean
    element :legacy_free_busy_status
    element :location
    element :when
    element :is_meeting, :type => Boolean
    element :is_cancelled, :type => Boolean
    element :is_recurring, :type => Boolean
    element :meeting_request_was_sent, :type => Boolean
    element :is_response_requested, :type => Boolean
    element :calendar_item_type
    element :my_response_type
    element :organizer, :type => SingleRecipient
    element :required_attendees, :type => [Attendee]
    element :optional_attendees, :type => [Attendee]
    element :resources, :type => [Attendee]
    # Conflicting and adjacent meetings
    element :conflicting_meeting_count, :type => Integer
    element :adjacent_meeting_count, :type => Integer
    element :conflicting_meetings, :type => [CalendarItem]
    element :adjacent_meetings, :type => [CalendarItem]
    # Duration
    element :duration
    element :time_zone
    # Appointment
    element :appointment_reply_time, :type => Time
    element :appointment_sequence_number, :type => Integer
    element :appointment_state, :type => Integer
    # Recurrence specific data, only valid if CalendarItemType is RecurringMaster
    element :recurrence #, :type => Recurrence
    element :first_occurrence #, :type => OccurrenceInfo
    element :last_occurrence #, :type => OccurrenceInfo
    element :modified_occurrences #, :type => [OccurrenceInfo]
    element :deleted_occurrences #, :type => [DeletedOccurrenceInfo]
    element :meeting_time_zone #, :type => TimeZone
    # Other properties
    element :conference_type, :type => Integer
    element :allow_new_time_proposal, :type => Boolean
    element :is_online_meeting, :type => Boolean
    element :meeting_workspace_url
    element :net_show_url

    def create_additional_options
      { send_meeting_invitations: "SendToAllAndSaveCopy" }
    end

    def delete_additional_options
      { send_meeting_cancellations: "SendToAllAndSaveCopy" }
    end
  end
end
