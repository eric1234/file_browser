lib 'test_gem_locator.rb', <<FILE
class TestGemLocator < Rails::Plugin::Locator
  def plugins
    Rails::Plugin.new(File.join(File.dirname(__FILE__), *%w(.. .. ..)))
  end
end
FILE

lib 'tasks/file_browser_tasks.rake', <<FILE
require File.join(File.dirname(__FILE__), *%w(.. .. .. .. lib file_browser rails_tasks))
FILE

environment <<CONFIG
require 'test_gem_locator'
config.plugin_locators << TestGemLocator
CONFIG

initializer 'file_browser_config.rb', <<REGISTER
FileBrowser.storages[:local] =
  FilesystemStorage.new Rails.root.join('../fixtures/fs_storage')
REGISTER

file 'public/javascripts/stub.js', <<JS
Event.observe(document, 'dom:loaded', function() {

  Event.observe(document, 'file_browser:select', function(event) {
    alert(event.memo+' selected');
  });

});
JS

rake 'file_browser:assets:copy'
