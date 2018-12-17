require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'apartment/elevators/subdomain'

module TattooManager
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #switch tenants based on subdomain
    config.middleware.use Apartment::Elevators::Subdomain

    #use sidekiq for background workers
    config.active_job.queue_adapter = :sidekiq

    #point actionMailer to sendgrid
    ActionMailer::Base.smtp_settings = {
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      adress: 'smtp.sendgrid.net',
      domain: 'oauth-test-sample-app.herokuapp.com',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true,
    }
  end
end
