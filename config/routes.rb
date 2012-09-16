#custom routes for this plugin
if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
   scope "/projects/:project_id" , :name_prefix => 'project' do 
     resources :import_from_csv do 
       collection do
         post :csv_import
       end
    end
   end
  end
else
 ActionController::Routing::Routes.draw do |map|
  map.resources :import_from_csv, :name_prefix => 'project_', :path_prefix => '/projects/:project_id',:collection => {:csv_import => :post}
 end
end
