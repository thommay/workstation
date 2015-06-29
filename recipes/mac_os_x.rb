
node.set['homebrew']['formulas'] = %w{pkg-config readline python elixir hub go git macvim the_silver_searcher zsh}
include_recipe 'homebrew::install_formulas'

include_recipe 'macapps::evernote'
include_recipe 'macapps::dropbox'
include_recipe 'macapps::virtualbox'
include_recipe 'macapps::vagrant'

include_recipe 'mac_os_x::dock_preferences'

mac_os_x_userdefaults "com.apple.dock orientation" do
  domain "com.apple.dock"
  key "orientation"
  value "right"
  type "string"
  notifies :run, 'execute[killall Dock]'
end

mac_os_x_userdefaults "com.apple.finder EmptyTrashSecurely" do
  domain "com.apple.finder"
  key "EmptyTrashSecurely"
  value "true"
  type "bool"
end

hb_dir =  Etc.getpwuid(homebrew_owner).dir

git "#{hb_dir}/.rbenv" do
  repository "https://github.com/sstephenson/rbenv"
end

git "#{hb_dir}/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build"
end

git "#{hb_dir}/.rbenv/plugins/rbenv-default-gems" do
  repository "https://github.com/sstephenson/rbenv-default-gems"
end

git "#{hb_dir}/.rbenv/plugins/rbenv-ctags" do
  repository "https://github.com/tpope/rbenv-ctags.git"
end

git "#{hb_dir}/.vim" do
  repository "https://github.com/thommay/scaramanga"
end

git "#{hb_dir}/.dotfiles" do
  repository "https://github.com/thommay/dotfiles"
end

execute "rbenv install 2.2.0" do
  user homebrew_owner
  environment "PATH" => "#{hb_dir}/.rbenv/shims:#{hb_dir}/.rbenv/bin:#{ENV["PATH"]}"
  not_if "test -d #{hb_dir}/.rbenv/versions/2.2.0"
end

%w{ dotfiles vim}.each do |dir|
  execute "rake" do
    user homebrew_owner
    environment "PATH" => "#{hb_dir}/.rbenv/shims:#{hb_dir}/.rbenv/bin:#{ENV["PATH"]}"
    cwd "#{hb_dir}/.#{dir}"
  end
end
