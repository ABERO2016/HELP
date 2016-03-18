module Admin
  class MainController < Volt::ModelController
    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def survey(id)
      store._surveyforms.where(user_id: id).first.then do |s|
        redirect_to "/results/#{s.id}"
      end
    end

    # NOTE: Soon specify grad year
    def all_users
      store.users.skip(((params._page || 1).to_i - 1) * 10).limit(10).all
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
