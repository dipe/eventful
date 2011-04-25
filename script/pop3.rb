#!./script/rails runner

require 'net/imap'
require "highline/import"

imap = Net::IMAP.new('imap.gmail.com', 993, true)

user = ask("Gmail address: ")
password = ask("Password: ") { |q| q.echo = false }

imap.login(user, password)
imap.examine('INBOX')
imap.search(["ALL"]).each do |message_id|

  begin
    m = imap.fetch(message_id, "(BODY[TEXT] ENVELOPE)")[0]
    body = m.attr["BODY[TEXT]"]
    subject = m.attr["ENVELOPE"].subject[/\[Fehler\] Web-Sales [^:]+: (.*)/, 1]
    date = m.attr["ENVELOPE"].date
  rescue Exception => e
    puts "ignore #{e}"
    next
  end

  message = body[/\r\n\r\n(.*)\r\n\r\n/m, 1]
  application = 'WebSales'
  environment = body[/Web-Sales (.+):/, 1]
  controller = body[/Aktion:\s*(\w+)\#/, 1]
  action = body[/Aktion:\s*\w+\#(\w+)/, 1]
  session = body[/Session:\s*([0-9a-z]+)/, 1]
  node = body[/Knoten:\s*([0-9a-z-]+)/, 1]
  pid = body[/Prozess:\s*([0-9]+)/, 1]

  Event.create! :created_at => Time.rfc2822(date),
    :title => subject,
    :message => message,
    :environment => environment,
    :api_token => 'test1234',
    :controller => controller,
    :action => action,
    :session_id => session,
    :node => node,
    :pid => pid,
    :level => subject.match(/axis2/) ? 0 : 1

  print '.'  
end

puts 
