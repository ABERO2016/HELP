module Main
  class ClubsController < Volt::ModelController
    before_action :require_login
    # before_action :setup_club_table, only: :index

    def index
      # Add code for when the index view is loaded
      page._club ||= store.clubs.buffer
      page._competencies = []
    end

    def about
      # Add code for when the about view is loaded
    end

    # def setup_club_table
    #   params._sort_field ||= "name"
    #   params._sort_direction ||= 1
    #   page._table = {
    #     default_click_event: 'club_click',
    #     columns: [
    #     {title: "Club/Org Name", search_field: 'name', field_name: 'name', sort_name: 'name', shown: true},
    #     {title: "Description", search_field: 'desc', field_name: 'description', sort_name: 'description', shown: true},
    #     {title: "More Information", search_field: 'more_info', field_name: 'more_info', sort_name: 'more_info', shown: false},
    #     ]
    #   }
    # end

    def club_competencies(id)
      store._competencies.where(club_id: id).all
    end

    def toggle(item)
      if selected?
        page._competencies.delete(item)
      else
        page._competencies << item
      end
    end

    def new_club
      page._competencies = []
      page._club = store.clubs.buffer
    end

    def selected?
      page._competencies.include?(attrs.item)
    end

    def show_more(club_id = nil)
      page._competencies = []
      store.clubs.where(id: club_id).first.then do |club|
        page._club = club.buffer
      end
      club_competencies(club_id).each do |comp|
        page._competencies << "#{comp.name}"
      end
      `$('#ClubModal').modal('show');`
    end

    def save_club
      model.save!.then do |m|
        page._competencies.each do |c|
          m._competencies << {name: "#{c}"}
        end
        `$('#ClubModal').modal('hide');`
      end.fail do |er|
        puts "#{er}"
      end
    end

    def update_club
      model.save!.then do
        `$('#ClubModal').modal('hide');`
      end
    end

    def delete_and_close
      store.clubs.where(id: model.id).first.then do |club|
        store.clubs.delete(club)
      end
      `$('#ClubModal').modal('hide');`
    end

  end
end
