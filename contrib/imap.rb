#!/usr/bin/env ruby

require 'net/imap'
require 'time'

imap = Net::IMAP.new('imap.gmail.com', 993, true)
imap.login('ume.exceptions@googlemail.com', 'Fgg18:LAK')
imap.examine('INBOX')
imap.search(["ALL"]).each do |message_id|
  m = imap.fetch(message_id, "(BODY[TEXT] ENVELOPE)")[0]

  body = m.attr["BODY[TEXT]"]
  subject = m.attr["ENVELOPE"].subject
  date = m.attr["ENVELOPE"].date
  message = body[/\r\n\r\n(.*)\r\n\r\n/m, 1]
  application = 'Web-Sales'
  environment = body[/Web-Sales (.+):/, 1]
  controller = body[/Aktion:\s*(\w+)\#/, 1]
  action = body[/Aktion:\s*\w+\#(\w+)/, 1]
  session = body[/Session:\s*([0-9a-z]+)/, 1]
  node = body[/Knoten:\s*([0-9a-z]+)/, 1]
  pid = body[/Prozess:\s*([0-9a-z]+)/, 1]

  puts Time.rfc2822(date)
end
