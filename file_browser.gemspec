Gem::Specification.new do |s|
  s.name = 'file_browser'
  s.version = '0.3.0'
  s.homepage = 'http://wiki.github.com/eric1234/file_browser/'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.add_dependency 'rails', '>= 4.0.0'
  s.files = Dir['**/*'].reject do |f|
    f =~ /^test/ || f == 'file_browser.gemspec' || f =~ /^pkg/
  end
  s.has_rdoc = true
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'A Rails-gem for managing files'
  s.description = <<-DESCRIPTION
    Provides a web-based UI to manage a filesystem. Useful as an
    alternative to FTP and also to integrate with products such
    as CKEditor.
  DESCRIPTION
end
