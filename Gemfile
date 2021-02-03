source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.1"
# Use mysql as the database for Active Record
gem "mysql2", "0.5.3"
# bootstrapを使用する
gem "bootstrap-sass", "3.4.1"
# パスワードをハッシュ化するための最先端のハッシュ関数
gem "bcrypt", "3.1.13"
# テスト用ユーザ等の追加
gem "faker"
# ページネーション用のgem
gem "will_paginate"
gem "bootstrap-will_paginate"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# 画像のトリミングに使う
gem 'image_processing'
gem 'mini_magick'
gem "active_storage_validations"

# ログの出力先を標準出力にする
gem 'rails_semantic_logger'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "2.0.1"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver", "3.142.4"
  gem "webdrivers", "4.1.2"
  gem "rails-controller-testing", "1.0.4" # assigns(:user)などが使える
  gem "minitest", "~> 5.12"
  gem "minitest-reporters", "1.3.8"
  gem "guard", "2.16.2"
  gem "guard-minitest", "2.4.6"
end

group :production do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# guardの動作にrexmlが必要
gem "rexml"
