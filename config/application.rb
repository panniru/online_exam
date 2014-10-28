require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module OnlineExam
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.active_record.schema_format = :sql

    config.assets.enabled = true
    config.assets.version = '1.0'

    config.sass.preferred_syntax = :sass
    # config.time_zone = 'Central Time (US & Canada)'
    # config.active_record.default_timezone = 'Central Time (US & Canada)'

    config.autoload_paths += %W(#{Rails.root}/lib/)
    config.autoload_paths += %W(#{Rails.root}/app/presenters)
    config.autoload_paths += %W(#{Rails.root}/app/models/uploaders)
    config.angular_templates.module_name    = 'templates'
    config.angular_templates.ignore_prefix  = 'templates/'
    config.angular_templates.markups        = %w(erb haml)
    config.angular_templates.htmlcompressor = false
  end
end
