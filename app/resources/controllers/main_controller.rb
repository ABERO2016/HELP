module Resources
  class MainController < Volt::ModelController

    def index
      # Add code for when the index view is loaded
      #self.model = store._surveyforms.buffer
    end

    def about
      # Add code for when the about view is loaded
    end
    def displayOrgs
      if params._type_filter === 'self_aware'
      elsif params._type_filter === 'intentional_learner'
      elsif params._type_filter === 'communicates_effectively'
      elsif params._type_filter === 'develops_relationships'
      elsif params._type_filter === 'diversity_and_difference'
      elsif params._type_filter === 'engaging_leadership'
      elsif params._type_filter === 'directive_leadership'
      elsif params._type_filter === 'champions_effective_processes'
      elsif params._type_filter === 'problem_solving'
      elsif params._type_filter === 'strategic_perspective'
      elsif params._type_filter === 'ethics_and_integrity'
      else #Innovative Spirit

      end
    end
    private

    # the main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._controller and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end
  end
end
=begin
SELF_AWARE = ['Career Counseling and Advising,Club Sports','Connecting Mentoring Program','Crain All-University Leadership Conference','Engineering Internship Work Term','Faith and Learning Scholars','KNW 2300 - Introduction to Engineering Design',
'Multicutural Greek Council (MGC)','National Pan-Hellenic Council (NPHC)','PanHellenic Council (PHC)'
,'Hart Impact Program,Human Centered Design','Institute for Electrical and Electronic Engineers (IEEE)'
,'James E. Caswell Undergraduate Leadership Fellows Program','Emerging Leaders','Learning Management Strategies Workshop'
,'Lyle Engineering in the City','Mustang Intersections','Multicultural Student Organizations'
,'Mustang Corral Directors','Mustang Corral Leaders','Outdoor Adventures','Residence Assistant'
,'SMU Service House','Spirit Squads','Student Affairs Program Council'
,'Student Engineering Joint Council (SEJC)','Student Organizations (ORGS)','Theta Tau: Beta Chapter',
'Women"s Interest Network','Worship Services','Co-op and Internships','ENGR 1101 - Engineering and Beyond']
=end
