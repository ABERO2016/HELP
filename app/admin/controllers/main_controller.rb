module Admin
  class MainController < Volt::ModelController
    before_action :require_login
    before_action :setup_user_table, only: :users
    before_action :setup_user_outreach_table, only: :index

    def index
      # Add code for when the index view is loaded
    end

    def users
      page._email = ""
      self.model ||= store.users.buffer
    end

    def setup_user_table
      params._type_filter ||= "#{Time.now.year}"
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

    def setup_user_outreach_table
      params._type_filter ||= "#{Time.now.year}"
      params._sort_field ||= "last_name"
      params._sort_direction ||= 1
      page._table = {
        default_click_event: 'user_click',
        columns: [
        {title: "First Name", search_field: 'first', field_name: 'first_name', sort_name: 'first_name', shown: true},
        {title: "Last Name", search_field: 'last', field_name: 'last_name', sort_name: 'last_name', shown: true},
        {title: "How you heard about Help?", field_name: 'mktg', sort_name: 'mktg', shown: true},
        ]
      }
    end

    def survey(id)
      `$('#myModal').modal('hide');`
      `$("body").removeClass("modal-open");`
      store._surveyforms.where(user_id: id).first.then do |s|
        redirect_to "/results/#{s.id}"
      end
    end

    # NOTE: Soon specify grad year
    def users
      if params._type_filter != 'all'
        store.users.where(graduation_year: "#{params._type_filter}").all
      else
        store.users.all
      end
    end

    def show_user_detail(user_id = nil)
      self.model = store.users.where(id: user_id).first
      `$('#myModal').modal('show');`
    end

    def send_email
      if page._email == ''
        `swal("Error", "Please Provide a valid email!", "error")`
      else
        `swal("Sent!", "The invitation email has been sent!", "success")`
        emails = page._email.split(';')
        EmailHandlerTask.send_email(emails)
        page._email = ''
      end
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
