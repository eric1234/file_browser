require 'fileutils'
require 'rake/testtask'
require 'rake/gempackagetask'

desc 'Prepare testing by creating test app'
task :test_app do
  sh "rails -q -m test/test_app_template.rb test/test_app" unless
    File.exists? 'test/test_app'
end

spec = eval File.read('file_browser.gemspec')
Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = false
end

Rake::TestTask.new(:test => :test_app) do |task|
  task.libs << "lib"
  task.libs << "test"
  task.pattern = "test/*/*_test.rb"
  task.verbose = false
end

task :default => :test