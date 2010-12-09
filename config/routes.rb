Rails.application.routes.draw do
  controller :uploaded_files do
    get ':storage/uploaded_files/select/:integration/(*path)' => :index,
      :as => 'select_uploaded_file'
    get ':storage/uploaded_files/index/(*path)' => :index,
      :as => 'uploaded_files'
    get ':storage/uploaded_files/(*path)' => :show,
      :as => 'uploaded_file'
    post ':storage/uploaded_files/drop/:integration' => :create,
      :defaults => {:path => [], :dropbox => true},
      :as => 'drop_uploaded_file'
    post ':storage/uploaded_files/(*path)' => :create,
      :as => 'create_uploaded_file'
    delete ':storage/uploaded_files/(*path)' => :destroy,
      :as => 'delete_uploaded_file'
  end
end
