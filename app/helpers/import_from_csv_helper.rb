module ImportFromCsvHelper
  def format_error(done,total,error_messages)
    final_message=""
    final_message=%{#{done} out of #{total} new issues have been created}
    final_message << %{<p>Details:</p>}
    final_message << %{<ul>}
    for message in error_messages
      final_message << %{<li>#{message}</li>}
    end
    final_message << %{</ul>}
    final_message << %{<p>#{l(:required_format)}</p>}
    return final_message
  end

  def has_story_tracker?(project)
    found=project.trackers.find_by_name("Story")
    return found.id  if found
  end

end