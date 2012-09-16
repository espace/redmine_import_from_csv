require 'redmine'
# Hooks
require_dependency 'import_from_csv_hooks'
require File.dirname(__FILE__) + '/test/factories.rb'
Redmine::Plugin.register :redmine_import_from_csv do
  name 'Redmine Import From Csv plugin'
  author 'Basayel Said'
  description 'As a TL, can upload csv file with stories to automatically add stories'
  version '0.0.1'
  project_module :issue_tracking do
    permission :import_issues_from_csv, {:import_from_csv => [:index, :csv_import]} ,:require => :member  
  end
end

#Redmine::AccessControl.map do |map|
#  map.project_module :issue_tracking do |map|
#    map.permission :import_from_csv, {:import_from_csv => [:index, :csv_import]}
#  end
#end

#Redmine::MenuManager.map :project_menu do |menu|
#  menu.push :import_from_csv, { :controller => 'import_from_csv', :action => 'index' }, :caption => 'Import from CSV', :after => :activity, :param => :project_id
#end
