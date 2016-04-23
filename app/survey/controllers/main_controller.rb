module Survey
  class MainController < Volt::ModelController
    before_action :require_login

    def index
      # Add code for when the index view is loaded
      self.model = store._surveyforms.buffer
    end

    def about
      # Add code for when the about view is loaded
    end

    def results
      self.model = store._surveyforms.where(id: params.id).first
    end

    def user
      store.users.where(id: model._user_id).first.then do |user|
        user
      end
    end

    def options
      Volt::Model.new( {

        # identity the chart in volt
        id: 'chart',

        mode: :chart,

        # highcharts options
        chart: {
          type: 'line',
          renderTo: 'chart',
        },
        title: {
          text: 'Competencies'
        },
        xAxis: {
          categories: ['Self Awareness', 'Intentional Learner', 'Communication', 'Relationship Development', 'Dviersity Difference', 'Engaging Leadership', 'Directive Leadership' ,'Champions', 'Problem Solving', 'Strategic Perspective', 'Ethics Integrity', 'Innovative Spirit']
        },
        yAxis: {
          title: {
              text: 'Score',
          },
          max: 100
        },
        series: [
          {
            name: model._good_leader,
            data: [100, 100, 100, 100]
          },
          {
            name: model._bad_leader,
            data: [5, 7, 3, 10]
          },
          {
            name: "You",
            data: [self_awareness, intentional_learner, communication, relationship_development, diversity_difference, engaging_leadership, directive_leadership, champions, problem_solving, strategic_perspective, ethics_integrity, innovative_spirit]
          }
        ]
      } )
  end

    def surveys
      Volt.current_user_id.then do |id|
        store._surveyforms.where(user_id: id).all
      end
    end

    def view?
      view = false
      if Volt.current_user.survey_taken?
        view = true
      elsif Volt.current_user.admin?
        view = true
      end
      view
    end

    def save_survey
      `swal({   title: "Are you sure?",
        text: "Make sure you've answered all questions to the best of your ability!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#428bca",
        confirmButtonText: "Submit!",
        closeOnConfirm: false }, function(){`
          Volt.current_user_id.then do |id|
            model._user_id = id
            model._competency_one = competencies[0][:competency]
            model._competency_two = competencies[1][:competency]
            model._date = Time.now
            model.save!.then do
              Volt.current_user._survey_status = 'taken'
              `swal("Submitted", "Thank you for taking the survey. You may now review your results!", "success");`
              redirect_to '/'
            end.fail do |err|
              `swal("Error", "Something went wrong!", "error");`
            end
          end
        `});`
    end

    ###########################
    # Leadership Competencies #
    ###########################
    def self_awareness
      sum = _q12_0_c.to_i + _q12_1_c.to_i + _q12_2_c.to_i + _q12_3_c.to_i + _q12_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def intentional_learner
      sum = _q13_0_c.to_i + _q13_1_c.to_i + _q13_2_c.to_i + _q13_3_c.to_i + _q13_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def communication
      sum = _q12_4_c.to_i + _q13_4_c.to_i + _q14_4_c.to_i + _q16_4_c.to_i + _q22_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def relationship_development
      sum = _q14_0_c.to_i + _q14_1_c.to_i + _q14_2_c.to_i + _q14_3_c.to_i + _q14_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def diversity_difference
      sum = _q15_0_c.to_i + _q15_1_c.to_i + _q15_2_c.to_i + _q15_3_c.to_i + _q15_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def engaging_leadership
      sum = _q16_0_c.to_i + _q16_1_c.to_i + _q16_2_c.to_i + _q16_3_c.to_i + _q16_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def directive_leadership
      sum = _q22_0_c.to_i + _q22_1_c.to_i + _q22_2_c.to_i + _q22_3_c.to_i + _q22_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def champions
      sum = _q17_0_c.to_i + _q17_1_c.to_i + _q17_2_c.to_i + _q17_3_c.to_i + _q17_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def problem_solving
      sum = _q18_0_c.to_i + _q18_1_c.to_i + _q18_2_c.to_i + _q18_3_c.to_i + _q18_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def strategic_perspective
      sum = _q19_0_c.to_i + _q19_1_c.to_i + _q19_2_c.to_i + _q19_3_c.to_i + _q19_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def ethics_integrity
      sum = _q20_0_c.to_i + _q20_1_c.to_i + _q20_2_c.to_i + _q20_3_c.to_i + _q20_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    def innovative_spirit
      sum = _q21_0_c.to_i + _q21_1_c.to_i + _q21_2_c.to_i + _q21_3_c.to_i + _q21_4_c.to_i
      ((sum / 20) * 100).round(2)
    end

    #######################
    # Focus Area Averages #
    #######################
    def personal_leadership
      ((self_awareness + intentional_learner + communication) / 3).round(2)
    end

    def relational_leadership
      ((relationship_development + diversity_difference + engaging_leadership) / 3).round(2)
    end

    def functional_leadership
      ((directive_leadership + champions + problem_solving) / 3).round(2)
    end

    def leading_in_context
      ((strategic_perspective + ethics_integrity + innovative_spirit) / 3).round(2)
    end

    ########################
    # Assign Competencies   #
    ########################
    def competencies
      comp = []
      comp << {competency: "Innovative Spirit", value: innovative_spirit}
      comp << {competency: "Ethics Integrity", value: ethics_integrity}
      comp << {competency: "Strategic Perspective", value: strategic_perspective}
      comp << {competency: "Problem Solving", value: problem_solving}
      comp << {competency: "Champions Effective Processing", value: champions}
      comp << {competency: "Directive Leadership", value: directive_leadership}
      comp << {competency: "Engaging Leadership", value: engaging_leadership}
      comp << {competency: "Diversity Difference", value: diversity_difference}
      comp << {competency: "Relationship Development", value: relationship_development}
      comp << {competency: "Communication", value: communication}
      comp << {competency: "Intentional Learner", value: intentional_learner}
      comp << {competency: "Self Awareness", value: self_awareness}
      comp.sort_by { |hsh| hsh[:value] }.reverse!
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
