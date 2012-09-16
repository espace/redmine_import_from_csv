#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.resources :import_from_csv, :name_prefix => 'project_', :path_prefix => '/projects/:project_id',:collection => {:csv_import => :post}
end
