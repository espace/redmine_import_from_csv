require File.dirname(__FILE__) + '/../test_helper'
require 'import_from_csv_controller'
require 'object_mock'
class ImportFromCsvControllerTest < ActionController::TestCase
  fixtures :projects, :versions, :users, :roles, :members, :member_roles, :issues,
           :trackers, :projects_trackers, :issue_statuses,:enumerations
  context "Importing new issues from csv file" do
    setup do
      @project     = Factory.create(:project)
      @module      = Factory.create(:enabled_module,:name=>"import_issues")
      @project.enabled_modules <<  @module
      @request     = ActionController::TestRequest.new
      @response    = ActionController::TestResponse.new
      User.current = User.first
      puts ">>>>>>>>#{User.current.firstname}"
    end
    context "get index" do
      should "response successfully" do
        ApplicationController.class_mock(:authorize=>true) do
          get :index,:project_id=>@project.identifier
          assert_response :success
        end
      end
    end
    
    context "importing proper csv file" do
      setup do
        trackers=[]
        @t=Factory.create(:tracker)
        puts ">>>>>>>>>>Tracker Name:: #{@t.name}"
        trackers << @t
        @project.trackers=trackers
        File.open(File.dirname(__FILE__) + '/../test1.csv', 'wb') do |file| 
          file.puts "Themes,Stories,Notes,Estimation (man days)"
          file.puts "A1,Subject1,Desc1,4"
          file.puts "A2,Subject2,Desc2,8"
          file.puts "A3,Subject3,Desc3,14"
        end
      end
      
      should "create new issues successfully" do
        old_count=Issue.count
        file=File.open(File.dirname(__FILE__) + '/../test1.csv','r')
        ApplicationController.class_mock(:authorize=>true) do
          post :csv_import,:project_id=>@project.identifier,:dump=>{:file=>file,:tracker_id=>@t.id}
          assert flash[:notice]
          assert_redirected_to :controller => :issues, :action => :index,:project_id=>@project.id
          assert_equal Issue.count,old_count+3
        end
      end
    end
    context "import bad csv file" do
      setup do
        trackers=[]
        @t=Factory.create(:tracker)
        trackers << @t
        @project.trackers=trackers
        File.open(File.dirname(__FILE__) + '/../test2.csv', 'wb') do |file| 
          file.puts "Themes,Stories,Notes"
          file.puts "A1,,Desc1,8"
        end  
      end
      
      should "not import successfully" do
        old_count=Issue.count
        file=File.open(File.dirname(__FILE__) + '/../test2.csv','r')
        ApplicationController.class_mock(:authorize=>true) do
          post :csv_import,:project_id=>@project.identifier,:dump=>{:file=>file,:tracker_id=>@t.id}
          assert flash[:error]
          assert_redirected_to :controller => :issues, :action => :index,:project_id=>@project.id
          assert_equal Issue.count,old_count
        end
      end
    end
  end
#  def teardown
#    File.delete(File.dirname(__FILE__) + '/../test1.csv') if File.exist?(File.dirname(__FILE__) + '/../test1.csv')
#    File.delete(File.dirname(__FILE__) + '/../test2.csv') if File.exist?(File.dirname(__FILE__) + '/../test2.csv')
#  end
  
end