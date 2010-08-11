namespace :file_browser do
  namespace :assets do

    desc "Copy assets (i.e. public/) directory to main public/"
    task :copy => [:copy_javascripts, :copy_images, :copy_stylesheets]

    task :copy_javascripts do
      if file_browser_path('public/javascripts/').exist?
        src = file_browser_path('public/javascripts/').children
        dest = app_path 'public/javascripts/'
        FileUtils.cp_r src, dest
      end
    end

    task :copy_stylesheets do
      if file_browser_path('public/stylesheets/').exist?
        src = file_browser_path('public/stylesheets/').children
        dest = app_path 'public/stylesheets/'
        FileUtils.cp_r src, dest
      end
    end

    task :copy_images do
      if file_browser_path('public/images/').exist?
        src = file_browser_path('public/images/').children
        dest = app_path 'public/images/file_browser/'
        FileUtils.rm_rf dest.children
        FileUtils.cp_r src, dest
      end
    end

    private
    
    def file_browser_path(path)
      Pathname.new(__FILE__).realpath.dirname.join('../../').join path
    end
    
    def app_path(path)
      returning(Pathname.getwd.realpath.join(path)) do |p|
        p.mkpath
      end
    end

  end
end