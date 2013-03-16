require "rspec"
require "webmock/rspec"
require "thebigdb"

RSpec.configure do |config|
  config.order = "random"

  config.before(:each) do
    TheBigDB::DEFAULT_CONFIGURATION["api_host"] = "fake.test.host"
    TheBigDB.reset_default_configuration
  end

  config.after(:each) do
    TheBigDB.reset_default_configuration
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end