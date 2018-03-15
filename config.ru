Bundler.require

require "securerandom"
require "pghero/engine"
require "rails/all"

class PGHeroSolo < Rails::Application
  routes.append do
    mount PgHero::Engine, at: ENV['MOUNTPOINT'] || "/"
  end

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = true
  config.secret_key_base = ENV['SECRET_KEY_BASE'] || SecureRandom.hex(30)

  # Serve static files
  config.public_file_server.enable = true

  # Log to STDOUT
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
end

PGHeroSolo.initialize!
run PGHeroSolo
