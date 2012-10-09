class ImportFromCsvController < ApplicationController
  before_filter :get_project,:authorize
  helper :import_from_csv
  include ImportFromCsvHelper
  include ApplicationHelper
  
  #menu_item :import_from_csv
  require 'csv'
  def index
    respond_to do |format|
      format.html
    end
  end
  
  def csv_import
    if params[:dump][:file].blank?
      error = 'Please, Select CSV file'
      redirect_with_error error, @project
    elsif params[:dump][:daily_working_hrs].blank?
      error = 'Please, Enter Expected daily working hours'
      redirect_with_error error, @project
    else
      begin
        done=0;total=0
        error_messages=[]
        tracker=@project.trackers.find(params[:dump][:tracker_id])
        infile = params[:dump][:file].read
        parsed_file = CSV.parse(infile)
        parsed_file.each_with_index  do |row,index|
          story_id=row[0];subject=row[1]
          description=row[2];estimated_hrs=row[3]
          next if index==0
          total=total+1
          issue=Issue.new
          issue.project=@project
          issue.author=User.current
          issue.tracker=tracker
          issue.text_id=story_id if issue.has_attribute? 'text_id'
          issue.subject=subject
          issue.description=(subject.nil? ? "" : subject)+(description.nil? ? "" : "\n\nh3. Notes\n\n"+description)   
          issue.estimated_hours=estimated_hrs.to_f * params[:dump][:daily_working_hrs].to_f unless estimated_hrs.blank? and params[:dump][:daily_working_hrs].blank?
          if issue.save
            done=done+1
          else # invalid
            if issue.has_attribute? 'text_id'
              duplicate_issue = Issue.all(:conditions => "text_id = BINARY '#{story_id}' AND project_id = #{@project.id}")
              if duplicate_issue.blank?
                error_messages << "Line:#{index+1}..Error: #{issue.errors.full_messages.uniq.join(', ')}"
              else
                i_id = duplicate_issue.first.id
                error_messages << "Line:#{index+1}..Error: #{issue.errors.full_messages.uniq.join(', ')} for this issue <a href=\"/issues/#{i_id}\">##{i_id}</a>"
              end 
            else
              error_messages << "Line:#{index+1}..Error: #{issue.errors.full_messages.uniq.join(', ')}"
            end         
          end
        end
      rescue CSV::MalformedCSVError => e
        redirect_with_error e.message, @project
        return
      end
      if done==total
        flash[:notice]="CSV Import Successful, #{done} new issues have been created"
      else
        flash[:error]=format_error(done,total,error_messages)
      end
      redirect_to :controller=>"issues",:action=>"index",:project_id=>@project.identifier
    end
  end
  
  def redirect_with_error(err,project)
    flash[:error]=err
    redirect_to :controller=>"import_from_csv",:action=>"index",:project_id=>project.identifier
  end
 
  def get_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end