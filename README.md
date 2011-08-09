Exchanger
=========

Ruby library for accessing Microsoft Exchange using Exchange Web Services.
This library tries to make creating and updating items as easy as possible.
It will keep track of changed properties and will update only them.

Supported operations
====================

* FindItem, GetItem, CreateItem, UpdateItem, DeleteItem
* FindFolder, GetFolder
* ResolveNames, ExpandDL

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

Alternatives
============

* [github.com/jrun/ews-api](http://github.com/jrun/ews-api)
* [github.com/zenchild/Viewpoint](http://github.com/zenchild/Viewpoint)
