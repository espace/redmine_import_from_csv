module ApplicationHelper
  def has_story_tracker?(project)
    found=project.trackers.find_by_name("Story")
    return found.id  if found
  end
end