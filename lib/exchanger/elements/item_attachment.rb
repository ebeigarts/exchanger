module Exchanger
  # The ItemAttachment element represents an Exchange item that is attached to another Exchange item.
  #
  # https://msdn.microsoft.com/en-us/library/office/aa562997(v=exchg.150).aspx
  class ItemAttachment < Attachment
    element :item, type: Item
    element :message, type: Message
    element :calendar_item, type: CalendarItem
    element :contact, type: Contact
    element :task, type: Task
    element :meeting_message, type: MeetingMessage
    element :meeting_request, type: MeetingRequest
    element :meeting_response, type: MeetingResponse
    element :meeting_cancellation, type: MeetingCancellation
  end
end
