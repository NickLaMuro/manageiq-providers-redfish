if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com' if ENV['CI']
  config.cassette_library_dir = File.join(ManageIQ::Providers::Redfish::Engine.root, 'spec/vcr_cassettes')
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    :match_requests_on            => %i(method uri body),
    :update_content_length_header => true
  }
  if Rails.application.secrets.redfish.nil?
    # Keep in sync with :vcr trait in spec/factories/ext_management_system.rb!
    config.filter_sensitive_data("REDFISH_HOST") { "redfishhost" }
  end
end

Dir[Rails.root.join("spec/shared/**/*.rb")].each { |f| require f }
Dir[ManageIQ::Providers::Redfish::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }
