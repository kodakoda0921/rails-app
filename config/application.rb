require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
    # ログにrequest_idの名前付きタグをつける
    config.log_tags = { request_id: :request_id }
    # ログをファイル出力する
    config.rails_semantic_logger.add_file_appender = true
    # 標準出力のみに出力
    config.semantic_logger.add_appender(io: $stdout, level: config.log_level)
    # :
    # config.action_cable.mount_path = '/websocket'
  end
end
