module Main
  class ClubsController < Volt::ModelController
    before_action :require_login

    def index
      # Add code for when the index view is loaded
      puts "Clubs"
    end

    def about
      # Add code for when the about view is loaded
    end

  end
end
