environment <<CONFIG
  require File.join(File.dirname(__FILE__), *%w(.. .. .. lib file_browser.rb))
CONFIG

gem 'ruby-debug'

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
