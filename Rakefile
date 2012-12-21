require 'bundler'
Bundler::GemHelper.install_tasks

desc 'Prepare testing by creating test app'
task :test_app do
  sh "rails new test/test_app -q -m test/test_app_template.rb" unless
    File.exists? 'test/test_app'
end

require 'rake/testtask'
Rake::TestTask.new(:test => :test_app) do |task|
  task.libs << "lib"
  task.libs << "test"
  task.pattern = "test/*/*_test.rb"
  task.verbose = false
end
task :default => :test
