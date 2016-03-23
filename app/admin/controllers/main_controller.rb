module Admin
  class MainController < Volt::ModelController
    before_action :require_login
    before_action :setup_main_table, only: :users

    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def users
      self.model ||= store.users.buffer
    end

    def setup_main_table
      params._type_filter ||= 'all'
      params._sort_field ||= "last_name"
      params._sort_direction ||= 1
      page._table = {
        default_click_event: 'user_click',
        columns: [
        {title: "First Name", search_field: 'first', field_name: 'first_name', sort_name: 'first_name', shown: true},
        {title: "Last Name", search_field: 'last', field_name: 'last_name', sort_name: 'last_name', shown: true},
        {title: "SMU ID", search_field: 'smu_id', field_name: 'smu_id', sort_name: 'smu_id', shown: true},
        {title: "Major", search_field: 'major', field_name: 'major', sort_name: 'major', shown: true},
        # {title: "Major", search_field: 'major', field_name: 'major', sort_name: 'major', shown: true},
        # {title: "Address", field_name: 'address', sort_name: 'address', shown: false},
        # {title: "City", search_field: 'city', field_name: 'city', sort_name: 'city', shown: true}
        ]
      }
    end

    def survey(id)
      `$('#myModal').modal('hide');`
      store._surveyforms.where(user_id: id).first.then do |s|
        redirect_to "/results/#{s.id}"
      end
    end

    # NOTE: Soon specify grad year
    def all_users
      store.users.all
    end

    def show_user_detail(user_id = nil)
      puts "user info #{user_id}"
      self.model = store.users.where(id: user_id).first
      `$('#modalButton').trigger('click');`
    end

    private

    # the main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._controller and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    def allow_access(user_id)
      store.users.where(id: user_id).first.then do |user|
        `swal("Sent!", "User now has access to take the survey!", "success")`
        user._survey_status = 'in progress'
      end
    end
  end
end
