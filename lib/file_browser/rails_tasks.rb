# Some glue to make it easy to include Rails-specific rake tasks in
# your Rails application. Simply put the following at the bottom of
# your Rakefile:
#
#   require 'file_browser/rails_tasks'
glob = File.join File.dirname(__FILE__), '../tasks/*.rake'
Dir[glob].each {|ext| load ext}