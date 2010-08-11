ActionController::Routing::Routes.draw do |map|
  map.select_uploaded_file ':storage/uploaded_files/select/:integration/*path',
    :controller => 'uploaded_files', :action => 'index',
    :conditions => {:method => :get}
  map.uploaded_files ':storage/uploaded_files/index/*path',
    :controller => 'uploaded_files', :action => 'index',
    :conditions => {:method => :get}
  map.uploaded_file ':storage/uploaded_files/*path',
    :controller => 'uploaded_files', :action => 'show',
    :conditions => {:method => :get}
  map.drop_uploaded_file ':storage/uploaded_files/drop/:integration',
    :controller => 'uploaded_files', :action => 'create',
    :path => [], :dropbox => true, :conditions => {:method => :post}
  map.create_uploaded_file ':storage/uploaded_files/*path',
    :controller => 'uploaded_files', :action => 'create',
    :conditions => {:method => :post}
  map.delete_uploaded_file ':storage/uploaded_files/*path',
    :controller => 'uploaded_files', :action => 'destroy',
    :conditions => {:method => :delete}
end