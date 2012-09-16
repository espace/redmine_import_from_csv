class ImportFromCsvController < ApplicationController
  before_filter :get_project,:authorize
  helper :import_from_csv
  include ImportFromCsvHelper
  #menu_item :import_from_csv
  require 'csv'
  def index
    respond_to do |format|
      format.html
    end
  end
  
  def csv_import
    begin
      done=0;total=0
      error_messages=[]
      tracker=@project.trackers.find(params[:dump][:tracker_id])
      parsed_file=CSV::Reader.parse(params[:dump][:file])
      parsed_file.each_with_index  do |row,index|
        story_id=row[0];subject=row[1]
        description=row[2];estimated_hrs=row[3]
        next if index==0
        total=total+1
        issue=Issue.new
        issue.project=@project
        issue.author=User.current
        issue.tracker=tracker
        issue.text_id=story_id
        issue.subject=subject
        issue.description=(subject.nil? ? "" : subject)+(description.nil? ? "" : "\n\nh3. Notes\n\n"+description)   
        issue.estimated_hours=estimated_hrs.to_f * params[:dump][:daily_working_hrs].to_f unless estimated_hrs.blank? and params[:dump][:daily_working_hrs].blank?
        if issue.save
          done=done+1
        else # invalid
          if issue.errors.invalid?(:text_id)
            i_id=Issue.find_by_text_id(story_id).id
            error_messages << "Line:#{index+1}..Error: #{issue.errors.full_messages.uniq.join(', ')} for this issue <a href=\"/issues/#{i_id}\">##{i_id}</a>"
          else
            error_messages << "Line:#{index+1}..Error: #{issue.errors.full_messages.uniq.join(', ')}"
          end
        end
      end
    rescue CSV::IllegalFormatError=>e
      redirect_with_error e.message,@project
      return
    end
    if done==total
      flash[:notice]="CSV Import Successful, #{done} new issues have been created"
    else
      flash[:error]=format_error(done,total,error_messages)
    end
    redirect_to :controller=>"issues",:action=>"index",:project_id=>@project.id
  end
  
  def redirect_with_error(err,project)
    flash[:error]=err
    redirect_to :controller=>"import_from_csv",:action=>"index",:project_id=>project.id
  end
 
  def get_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end