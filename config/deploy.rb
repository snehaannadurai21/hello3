# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "Hello"
set :repo_url, "https://github.com/snehaannadurai21/hello3.git"
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
