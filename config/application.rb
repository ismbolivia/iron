require_relative 'boot'
require 'csv'
require 'roo'
require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Iron
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = "America/La_Paz"
    #config.i18n.default_locale = :es
    config.i18n.fallbacks = [I18n.default_locale]
    config.autoload_paths += %W(#{Rails.root}/lib/validators)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
