Rails.application.configure do
  Bullet.enable = true
  Bullet.unused_eager_loading_enable = true
  Bullet.n_plus_one_query_enable     = true

  Faker::Config.locale = 'en-GB'
  # Settings specified here will take precedence over those in config/application.rb.

  config.active_storage.service = :test

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: "example.com" }
  config.s3_aws_config = { stub_responses: true }
  config.route53_aws_config = { stub_responses: true }

  config.middleware.use RackSessionAccess::Middleware
end

ActionMailer::Base.delivery_method = :test
