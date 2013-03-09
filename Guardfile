guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

notification :tmux,
  :display_message => true,
  :timeout => 3, # in seconds
  :default_message_format => '%s >> %s',
  :default => 'default',
  :success => 'default',
  :failed => 'colour1',
  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  :line_separator => ' > ' # since we are single line we need a separator
