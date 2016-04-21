# By default Volt generates this controller for your Main component
module Main
  class EventsController < Volt::ModelController
    before_action :require_login

    def index
      # Add code for when the index view is loaded
      puts "Events"
    end

    def about
      # Add code for when the about view is loaded
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

  end
end
