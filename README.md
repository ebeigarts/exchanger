Exchanger
=========

[![Continuous Integration status](https://secure.travis-ci.org/ebeigarts/exchanger.png)](http://travis-ci.org/ebeigarts/exchanger)

Ruby library for accessing Microsoft Exchange using Exchange Web Services.
This library tries to make creating and updating items as easy as possible.
It will keep track of changed properties and will update only them.

Supported operations
====================

* FindItem, GetItem, CreateItem, UpdateItem, DeleteItem, MoveItem
* FindFolder, GetFolder
* ResolveNames, ExpandDL
* GetUserAvailability
* GetAttachment, CreateAttachment, DeleteAttachment

Installing
==========

```bash
gem install exchanger
```

Configuration
=============

```ruby
Exchanger.configure do |config|
  config.endpoint = "https://domain.com/EWS/Exchanger.asmx"
  config.username = "username"
  config.password = "password"
  config.debug = true # show Exchange request/response info
end
```

or configure from YAML

```ruby
Exchanger::Config.instance.from_hash(YAML.load_file("#{Rails.root}/config/exchanger.yml")[Rails.env])
```

Examples
========

Creating and updating contacts
------------------------------

```ruby
folder = Exchanger::Folder.find(:contacts)
contact = folder.new_contact
contact.given_name = "Edgars"
contact.surname = "Beigarts"
contact.email_addresses = [ Exchanger::EmailAddress.new(:key => "EmailAddress1", :text => "me@example.com") ]
contact.phone_numbers = [ Exchanger::PhoneNumber.new(:key => "MobilePhone", :text => "+371 80000000") ]
contact.save # CreateItem operation
contact.company_name = "Example Inc."
contact.save # UpdateItem operation
contact.destroy # DeleteItem operation
```

Searching in Global Address Book
--------------------------------

```ruby
mailboxes = Exchanger::Mailbox.search("John")
```

Searching for Calendar items
----------------------------
More specific Exchange calendar documentation can be found
[here](https://msdn.microsoft.com/en-us/library/office/dn495614(v=exchg.150).aspx).

1) Return all Calendar items with recurring **master** appointments (without recurring).
Also called as non-expanded view.

```ruby
folder = Exchanger::Folder.find(:calendar, "email@example.com")
folder.items # return Exchanger::CalendarItem items
```

2) Return Calendar items providing
[CalendarView](https://msdn.microsoft.com/en-us/library/microsoft.exchange.webservices.data.calendarview(v=exchg.80).aspx) (with recurring).

Supported `CalendarView` options/attributes:
* max_entries_returned
* start_date
* end_date

```ruby
folder = Exchanger::Folder.find(:calendar, "email@example.com")
calendar_view_options = {
  start_date: (DateTime.now - 1.week),
  end_date:   DateTime.now,
}
folder.expanded_items(calendar_view_options) # return Exchanger::CalendarItem items
```

Running specs with Exchange Server
==================================

The easiest way is to sign up for a Microsoft Office 365 free trial. Please not that this needs to be the "Professional" version in order to be able to access the distribution lists. You also need to finish the setup, including e-mail, to be able to execute the steps below. Provisioning mail boxes can take up to 24 hours.

1. Create a random calendar entry in July 2016
2. Create a distribution list named 'Test'
   * This is available under the app "People" > "New group"
3. Create `spec/config.yml` with your Exchange credentials
4. Create `spec/fixtures/get_user_availability.yml` with your Exchange email address
5. Clear the recorded VCR cassettes by removing `spec/cassettes`
6. Run the specs `rake spec`

It looks like Office 365 trial has some rate limits,
so you may have to record the VCR cassettes for each spec separately.

```
Exchanger::Operation::ResponseError:
  An internal server error occurred. Try again later.
```

Alternatives
============

* [Exchange Clients in Ruby Toolbox](https://www.ruby-toolbox.com/categories/Exchange_Clients)
