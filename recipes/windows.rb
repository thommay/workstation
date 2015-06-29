include_recipe 'git'
include_recipe 'winbox::chocolatey_install'
include_recipe 'winbox::readline'
node.set['winbox']['create_profile'] = false
include_recipe 'winbox::powershell_dev'
include_recipe 'winbox::editor'
include_recipe 'winbox::git'


