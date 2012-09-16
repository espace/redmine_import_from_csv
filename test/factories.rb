require 'factory_girl'

Factory.define :project do |proj|
  proj.created_on "2006-07-19 19:13:59 +02:00"
  proj.sequence(:name){|n| "project#{n}" }
  proj.updated_on "2006-07-19 22:53:01 +02:00"
  proj.description "Recipes management application"
  proj.homepage "http://ecookbook.somenet.foo/"
  proj.is_public true
  proj.sequence(:identifier){|n| "project#{n}" } 
end

Factory.define :tracker do |tracker|
  tracker.name "Story"
  tracker.is_in_chlog true
  tracker.position 4
end

Factory.define :enabled_module do |em|
  em.sequence(:name){|n| "name#{n}"} 
end

#Factory.define :member do |member|
#  member.project_id {Factory.create(:project).id}
#end
#
#
#Factory.define :role do |r|
#  r.name "Team Leader"
#  r.position 3
#  r.assignable true
#  r.permissions {[:import_from_csv]}
#end