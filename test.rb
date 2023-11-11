# frozen_string_literal: true

require 'magicbell'
require 'json'

client = MagicBell::Client.new

res = client.create_broadcast({
                                title: 'New feature!',
                                content: 'We have a new feature for you!',
                                recipients: [
                                  { email: 'test@example.com' },
                                  { external_id: '123' }
                                ]
                              })

if res.success?
  puts 'Broadcast created successfully'
  broadcast = JSON.parse(res.body)
  puts broadcast
else
  puts 'Broadcast creation failed'
  puts res.body
end

user = client.user_with_email('test@example.com')
puts user.notifications.retrieve

puts user.mark_all_notifications_as_read
