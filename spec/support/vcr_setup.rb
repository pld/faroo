require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.filter_sensitive_data('<TOKEN>') {ENV["TOKEN"]}
end
