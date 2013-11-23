# Import from CSV

Redmine_import_from_CSV is a redmine plugin to add the feature of importing issues in CSV format.
As a team member with add issue permission, it shows a link to the side bar in isues page that redirects to select csv file form.
It checks that CSV file and Expected daily working hours' values are entered before proceeding.

"Story ID" field depends on Add Issue Text Id plugin (https://github.com/espace/add_issue_text_id). It will be ignored if plugin doesn't exist.

## Installation

* Compatible with redmine 2.1 and Rails 3.
* Clons the plugin into the plugins directory

  ```
    cd redmine-2.1.0
    cd plugins/
    git clone git://github.com/espace/redmine_import_from_csv.git
  ```
  
* You'll need to enable "Import issues from csv"  under "Issure Tracking" section in Administration >  roles and permissions

##License
Redmine_import_from_CSV is provided under the MIT License.

##Credits
* [modsaid](https://github.com/modsaid)
* [basayel](https://github.com/basayel)
* [Yasmine-Gaber](https://github.com/Yasmine-Gaber)
