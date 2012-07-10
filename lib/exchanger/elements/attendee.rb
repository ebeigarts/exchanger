module Exchanger
  # The Attendee element represents attendees and resources for a meeting.
  #
  # http://msdn.microsoft.com/en-us/library/aa580339.aspx
  class Attendee < Element
    element :mailbox, :type => Mailbox
    element :response_type # Unknown Organizer Tentative Accept Decline NoResponseReceived
    element :last_response_time, :type => Time

    def tag_name
      "Attendee"
    end
  end
end
