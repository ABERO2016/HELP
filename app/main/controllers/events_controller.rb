# By default Volt generates this controller for your Main component
module Main
  class EventsController < Volt::ModelController
    before_action :require_login
    # before_action :setup_club_table, only: :index

    def index
      # Add code for when the index view is loaded
      page._event ||= store.events.buffer
      page._competencies = []
      params._time ||= 'future'
    end

    def about
      # Add code for when the about view is loaded
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
      page._time = nil
      page._end_time = nil
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
      # if params._type_filter == 'all'
      if params._time == 'past'
        store.events.where({:date => { '$lt' => Time.now.strftime("%m/%d/%Y") } }).order(:date => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
      elsif params._time == 'today'
        store.events.where({:date => { '$eq' => Time.now.strftime("%m/%d/%Y") } }).order(:date => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
      else
        store.events.where({:date => { '$gte' => Time.now.strftime("%m/%d/%Y") } }).order(:date => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
      end
      # else
      #   events = []
      #   store.competencies.where(name: params._type_filter).all.each do |comp|
      #     unless events.include?(comp.event_id)
      #       store.events.where(id: comp.event_id).first.then do |item|
      #         events << {id: comp.event_id, name: "#{item.name}"}
      #       end
      #     end
      #   end
      #   sorted_events = events.sort_by{ |hash| hash['name'] }
      #   sorted_events.drop(((params._page || 1).to_i - 1) * 10).take(10)
      # end
    end

    def all_events_size
      # if params._type_filter == 'all'
      store._events.order(:date => 1).all.size
      # else
      #   events = []
      #   store.competencies.where(name: params._type_filter).all.each do |comp|
      #     unless events.include?(comp.event_id)
      #       store.events.where(id: comp.event_id).first.then do |item|
      #         events << {id: comp.event_id, name: "#{item.name}"}
      #       end
      #     end
      #   end
      #   events.size
      # end
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
      page._competencies = []
      store.events.where(id: event_id).first.then do |event|
        page._event = event.buffer
        if event._start_time
          page._time  = "#{event._start_time.hour}:#{event._start_time.strftime("%M")}"
        else
          page._time = nil
        end
        if event._end_time
          page._end_time = "#{event._end_time.hour}:#{event._end_time.strftime("%M")}"
        else
          page._end_time = nil
        end
      end
      event_competencies(event_id).each do |comp|
        page._competencies << "#{comp.name}"
      end
      `$('#EventModal').modal('show');`
    end

    def save_event
      if page._time
        time = page._time.split(":")
        model.start_time = Time.local(2017, 10, 10, time[0].to_i, time[1].to_i, 0)
      end
      if page._end_time
        end_time = page._end_time.split(":")
        model.end_time = Time.local(2017, 10, 10, end_time[0].to_i, end_time[1].to_i, 0)
      end
      model.save!.then do |m|
        page._competencies.each do |c|
          m._competencies << {name: "#{c}"}
        end
        `swal("Success", "Event was created!", "success");`
        `$('#EventModal').modal('hide');`
      end.fail do |er|
        `swal("Error", "Please make sure required fields are completed", "error");`
      end
    end

    def update_event
      time = page._time.split(":")
      model.start_time = Time.local(2017, 10, 10, time[0].to_i, time[1].to_i, 0)
      if page._end_time && page._end_time != "0:00" && page._end_time != ""
        end_time = page._end_time.split(":")
        model.end_time = Time.local(2017, 10, 10, end_time[0].to_i, end_time[1].to_i, 0)
      else
        model._end_time = nil
      end
      model.save!.then do |m|
        `swal("Success", "Event was saved!", "success");`
        `$('#EventModal').modal('hide');`
      end.fail do |er|
        `swal("Error", "Please make sure required fields are completed", "error");`
      end
      index
    end

    def info_is_link?
      model._rsvp.include?('http')
    end

    def delete_and_close
      `swal({   title: "Are you sure?",
        text: "Are you sure that you want to delete this event? You will lose all data!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d43f3a",
        confirmButtonText: "Delete!",
        closeOnConfirm: false }, function(){`
          store._competencies.where(event_id: model.id).all.each do |comp|
            comp.destroy
          end
          store.events.where(id: model.id).first.then do |event|
            store.events.delete(event)
          end
          `swal("Deleted", "Event has been deleted", "success");`
          `$('#EventModal').modal('hide');`
      `});`
    end
  end
end
