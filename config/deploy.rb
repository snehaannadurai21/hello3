# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "Hello"
set :repo_url, "https://github.com/snehaannadurai21/hello2.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/Hello"
set :branch, 'main'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Only keep the last 5 releases to save disk space
set :keep_releases, 5

set :puma_threads, [4, 16]
set :puma_workers, 4
set :puma_bind, "unix://#{fetch(:deploy_to)}/shared/tmp/sockets/puma.sock"

set :puma_state, "#{shared_path}/tmp/sockets/puma.state"
set :puma_preload_app, true
set :rbenv_type, :user
set :rbenv_ruby, '2.7.5'

set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}
set :rbenv_roles, :all
# Add the following line to your deploy.rb
before 'deploy:assets:precompile', 'deploy:bundle_install'

namespace :deploy do
  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, 'install --without development test'
      end
    end
  end
end


namespace :puma do
    desc "Restart Puma"
    task :restart do
      on roles(:app) do
        execute :sudo, :service, "puma restart"
      end
    end
  
    before "deploy:starting", "puma:restart"
    before "deploy:reverted", "puma:restart"
    after "deploy:published", "puma:restart"
  end
# Define tasks to restart Puma after certain events



# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
