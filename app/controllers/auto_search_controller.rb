class AutoSearchController < ApplicationController
  skip_authorization_check

  autocomplete :user, :user_id, :full => true, :scopes => [:exam_ceter_roles]

  autocomplete :user, :user_info, :column_name => :user_id, :full => true, :scopes => [:admins]

  autocomplete :student, :roll_number, :full => true, :extra_data => [:name, :semester]

  autocomplete :faculty, :name, :full => true, :extra_data => [:designation]

  autocomplete :course, :name, :full => true
  autocomplete :exam, :subject, :full => true
  autocomplete :exam, :exam_name, :full => true

  def get_autocomplete_items(parameters)
    items = super(parameters)
  end

end
