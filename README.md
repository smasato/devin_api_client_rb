# Devin API Client
[![Test](https://github.com/smasato/devin_api_client_rb/actions/workflows/rspec.yml/badge.svg)](https://github.com/smasato/devin_api_client_rb/actions/workflows/rspec.yml?query=branch%3Amain)

This Ruby gem is a client for the Devin API.

This gem is not officially supported by Cognition AI, Inc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devin_api'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install devin_api
```

## Usage

### Endpoint-based API

```ruby
require 'devin_api'

client = DevinApi::Client.new do |config|
  config.url = 'https://api.devin.ai'
  config.access_token = 'your_access_token'
end

# Sessions
sessions = client.list_sessions(limit: 10)
puts "Sessions: #{sessions}"

new_session = client.create_session(prompt: 'Build a simple web app')
session_id = new_session['id']
puts "Created session: #{session_id}"

session_details = client.get_session(session_id)
puts "Session details: #{session_details}"

message_response = client.send_message(session_id, message: 'How do I start?')
puts "Message response: #{message_response}"

# Upload files to a session
file = File.open('path/to/file.txt')
upload_response = client.upload_file(file)
puts "Upload response: #{upload_response}"

# Update session tags
tags_response = client.update_session_tags(session_id, tags: ['web', 'app'])
puts "Tags update response: #{tags_response}"

# Secrets
secrets = client.list_secrets
puts "Secrets: #{secrets}"

# Knowledge
knowledge_items = client.list_knowledge
puts "Knowledge items: #{knowledge_items}"

new_knowledge = client.create_knowledge(
  name: 'API Documentation',
  body: 'This is the API documentation for our service.',
  trigger_description: 'When API documentation is needed'
)
knowledge_id = new_knowledge['id']
puts "Created knowledge: #{knowledge_id}"

# Enterprise (for enterprise customers)
audit_logs = client.list_audit_logs(start_time: '2023-01-01T00:00:00Z')
puts "Audit logs: #{audit_logs}"

consumption = client.get_enterprise_consumption(period: 'current_month')
puts "Consumption: #{consumption}"
```

### Resource-based API

```ruby
require 'devin_api'

client = DevinApi::Client.new do |config|
  config.url = 'https://api.devin.ai'
  config.access_token = 'your_access_token'
end

# Resource-based usage
# Get a collection of sessions
sessions = client.sessions
sessions.each do |session|
  puts "Session ID: #{session.id}, Prompt: #{session[:prompt]}"
end

# Create a new session
new_session = client.sessions.create(prompt: 'Build a simple web app')
puts "Created session: #{new_session.session_id}"

# Get a specific session
session = client.session('session_id')

# Send a message to the session
response = session.send_message('How do I start?')

# Upload files to the session
files = [File.open('path/to/file.txt')]
upload_response = session.upload_files(files)

# Update session tags
session.update_tags(['web', 'app'])

# Pagination
next_page = sessions.next_page
if next_page
  next_page.each do |session|
    puts "Next page session: #{session.id}"
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smasato/devin_api_client_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
