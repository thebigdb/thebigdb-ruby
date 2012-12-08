require "rspec"
require "thebigdb"

RSpec.configure do |config|
  config.order = "random"

  config.after(:each) do
    TheBigDB.reset_default_values
  end
end