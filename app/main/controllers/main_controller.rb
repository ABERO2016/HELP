# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def in_progress?
      Volt.current_user._survey_status.then do |status|
        if status == 'in progress'
          true
        else
          false
        end
      end
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

    def has_competency?
      Volt.current_user._competency.then do |comp|
        if comp == '' || comp == nil
          false
        else
          true
        end
      end
    end

    def user_name(id)
      store.users.where(id: id).first.then do |user|
        user.name
      end
    end

    def upcoming_events
      store.events.where({:date => { '$gte' => Time.now.strftime("%m/%d/%Y") } }).order(:date => 1).all
    end

    def competency_one
      Volt.current_user.then do |user|
        user._competency
      end
    end

    def competency_two
      Volt.current_user.then do |user|
        user._competency2
      end
    end

    def go_to_survey
      Volt.current_user_id.then do |id|
        store._surveyforms.where(user_id: id).first.then do |s|
          redirect_to "/results/#{s.id}"
        end
      end
    end

    def save
      if !page._mktg.empty?
        Volt.current_user._mktg = page._mktg
        `swal("Thank You", "", "success");`
      else
        `swal("Error", "Please Select an option", "error");`
      end
    end

    def hide_submenu
      `$('#side-bar').fadeOut('slide',function(){
        	$('.mini-submenu').fadeIn();
          $('#sidebar').removeClass('col-sm-4 col-md-3')
          $('#main').removeClass('col-sm-8 col-md-9')
        });`
    end

    def show_submenu
      `$('#sidebar').addClass('col-sm-4 col-md-3')
      $('#main').addClass('col-sm-8 col-md-9')
      $('#side-bar').toggle('slide');
      $('.mini-submenu').hide();`
    end

    def show_nav
      puts `$('#collapse-navbar').css('display')`
      if `$('#collapse-navbar').css('display')` == 'none' || `$('#collapse-navbar').css('display')` == 'hidden'
        puts 'nav'
        `$('#collapse-navbar').css('display', 'block');`
      else
        `$('#collapse-navbar').css('display', 'none');`
      end
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end


    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end

    def active_button?
      url.path.split('/')[1] == 'results'
    end
  end
end
