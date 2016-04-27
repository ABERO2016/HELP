# By default Volt generates this controller for your Main component
module Main
  class EventsController < Volt::ModelController
    before_action :require_login
    # before_action :setup_club_table, only: :index

    def index
      # Add code for when the index view is loaded
      page._event ||= store.events.buffer
      page._competencies = []
      params._type_filter ||= "all"
    end

    def about
      # Add code for when the about view is loaded
    end

    def events
      params._type_filter ||= "all"
      puts params._type_filter
    end

    # def setup_club_table
    #   params._sort_field ||= "name"
    #   params._sort_direction ||= 1
    #   page._table = {
    #     default_click_event: '',
    #     columns: [
    #     {title: "Club/Org Name", search_field: 'name', field_name: 'name', sort_name: 'name', shown: true},
    #     {title: "Description", search_field: 'desc', field_name: 'description', shown: true},
    #     {title: "More Information", search_field: 'more_info', field_name: 'more_info', shown: false},
    #     ]
    #   }
    # end

    def new_event
      page._event = store._events.buffer
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

    def event_competencies(id)
      store._competencies.where(event_id: id).all
    end

    def toggle(item)
      if selected?
        page._competencies.delete(item)
      else
        page._competencies << item
      end
    end

    def user_events
      competency_one.then do |one|
        store.competencies.where(name: "#{one}").all
      end
    end

    def all_events
      if params._type_filter == 'all'
        store._events.order(:name => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
      else
        events = []
        store.competencies.where(name: params._type_filter).all.each do |comp|
          unless events.include?(comp.event_id)
            store.events.where(id: comp.event_id).first.then do |item|
              events << {id: comp.event_id, name: "#{item.name}"}
            end
          end
        end
        sorted_events = events.sort_by{ |hash| hash['name'] }
        sorted_events.drop(((params._page || 1).to_i - 1) * 10).take(10)
      end
    end

    def all_events_size
      if params._type_filter == 'all'
        store._events.order(:name => 1).all.size
      else
        events = []
        store.competencies.where(name: params._type_filter).all.each do |comp|
          unless events.include?(comp.event_id)
            store.events.where(id: comp.event_id).first.then do |item|
              events << {id: comp.event_id, name: "#{item.name}"}
            end
          end
        end
        events.size
      end
    end

    def the_event(event_id)
      store.events.where(id: event_id).first
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

    def show_more(event_id = nil)
      puts event_id
      page._competencies = []
      store.events.where(id: event_id).first.then do |event|
        page._event = event.buffer
      end
      event_competencies(event_id).each do |comp|
        page._competencies << "#{comp.name}"
      end
      `$('#EventModal').modal('show');`
    end

    def save_event
      model.save!.then do |m|
        page._competencies.each do |c|
          m._competencies << {name: "#{c}"}
        end
        `$('#EventModal').modal('hide');`
      end.fail do |er|
        puts "#{er}"
      end
    end

    def update_event
      model.save!.then do |m|
        `$('#EventModal').modal('hide');`
      end.fail do |er|
        puts "#{er}"
      end
      index
    end

    def delete_and_close
      store._competencies.where(event_id: model.id).all.each do |comp|
        comp.destroy
      end
      store.events.where(id: model.id).first.then do |event|
        store.events.delete(event)
      end
      `$('#EventModal').modal('hide');`
    end

  end
end
