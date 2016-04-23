module Main
  class ClubsController < Volt::ModelController
    before_action :require_login
    before_action :setup_club_table, only: :index

    def index
      # Add code for when the index view is loaded
      page._club ||= store.clubs.buffer
      page._competencies = []
    end

    def about
      # Add code for when the about view is loaded
    end

    def clubs
      page._club ||= store.clubs.buffer
      page._competencies = []
    end

    def setup_club_table
      params._sort_field ||= "name"
      params._sort_direction ||= 1
      page._table = {
        default_click_event: 'club_click',
        columns: [
        {title: "Club/Org Name", search_field: 'name', field_name: 'name', sort_name: 'name', shown: true},
        {title: "Description", search_field: 'desc', field_name: 'description', shown: true},
        {title: "More Information", search_field: 'more_info', field_name: 'more_info', shown: false},
        ]
      }
    end

    def new_club
      page._club = store._clubs.buffer
      page._competencies = []
    end

    def taken?
      Volt.current_user._survey_status.then do |status|
        if status == 'taken'
          true
        else
          false
        end
      end
    end

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

    def info_is_link?
      model._more_info.include?('http')
    end

    def user_clubs
      competency_one.then do |one|
        store.competencies.where(name: "#{one}").all
      end
    end

    def all_clubs
      store._clubs.order(:name => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
    end

    def competency_one
      Volt.current_user_id.then do |id|
        store._surveyforms.where(user_id: id).first.then do |survey|
          survey._competency_one
        end
      end
    end

    def competency_two
      Volt.current_user_id.then do |id|
        store._surveyforms.where(user_id: id).first.then do |survey|
          survey._competency_two
        end
      end
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
      model.save!.then do |m|
        `$('#ClubModal').modal('hide');`
      end.fail do |er|
        puts "#{er}"
      end
      index
    end

    def delete_and_close
      store._competencies.where(club_id: model.id).all.each do |comp|
        comp.destroy
      end
      store.clubs.where(id: model.id).first.then do |club|
        store.clubs.delete(club)
      end
      `$('#ClubModal').modal('hide');`
    end

  end
end
