# frozen_string_literal: true
set :application, 'tat-sbb-uat'
set :machine, 'stg.enrian.com'
set :repo_url, 'git@github.com:enrian/tatra-sbb.git'

set :rvm_type, :system
set :rvm_ruby_version, '2.3.0'

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{vendor/bundle log tmp/pids tmp/cache tmp/sockets}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'tmp:cache:clear'
      end
    end
  end
end
