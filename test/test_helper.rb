ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Parallelization disabled: each worker gets its own db (dbname_test_N),
    # so multi-worker runs were spawning one database per CPU core. workers: 1 keeps
    # everything on the single test database.
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
