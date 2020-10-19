# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/preferences'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::Preferences

  # Clean out the database state before the tests run
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    begin
      Rails.cache.clear
      reset_spree_preferences
    rescue Errno::ENOTEMPTY
    end
  end

  config.append_after do
    DatabaseCleaner.clean
  end

  config.order = :random
  Kernel.srand config.seed
end
