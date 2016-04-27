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
        id: 'chart',
        mode: :chart,
        chart: {
          type: 'line',
          renderTo: 'chart',
          height: 600
        },
        title: { text: 'Competencies' },
        xAxis: {
          categories: ['Self Awareness', 'Intentional Learner', 'Communicates Effectively', 'Relationship Development', 'Diversity Difference', 'Engaging Leadership', 'Directive Leadership' ,'Champions Effective<br> Processing', 'Problem Solving', 'Strategic Perspective', 'Ethics Integrity', 'Innovative Spirit']
        },
        yAxis: {
          title: {
              text: 'Score %',
          },
          max: 100
        },
        series: [
          {
            color: '#5cb85c',
            name: model._good_leader,
            data: [good_self_awareness, good_intentional_learner, good_communication, good_relationship_development, good_diversity_difference, good_engaging_leadership, good_directive_leadership, good_champions, good_problem_solving, good_strategic_perspective, good_ethics_integrity, good_innovative_spirit]
          },
          {
            color: '#d9534f',
            name: model._bad_leader,
            data: [bad_self_awareness, bad_intentional_learner, bad_communication, bad_relationship_development, bad_diversity_difference, bad_engaging_leadership, bad_directive_leadership, bad_champions, bad_problem_solving, bad_strategic_perspective, bad_ethics_integrity, bad_innovative_spirit]
          },
          {
            color: '#428bca',
            name: "You",
            data: [self_awareness, intentional_learner, communication, relationship_development, diversity_difference, engaging_leadership, directive_leadership, champions, problem_solving, strategic_perspective, ethics_integrity, innovative_spirit]
          }
        ]
      } )
    end

    def bar_graph_options
      Volt::Model.new( {
        id: 'bar_chart',
        mode: :chart,
        chart: {
          type: 'bar',
          renderTo: 'bar_chart',
          height: 500
        },
        title: {
          text: 'Competencies By Focus Area'
        },
        xAxis: {
          categories: ['Self Awareness', 'Intentional Learner', 'Communicates Effectively', 'Relationship Development', 'Dviersity Difference', 'Engaging Leadership', 'Directive Leadership' ,'Champions Effective<br> Processing', 'Problem Solving', 'Strategic Perspective', 'Ethics Integrity', 'Innovative Spirit']
        },
        yAxis: {
          title: {
              text: 'Score %',
          },
          max: 100
        },
        plotOptions: {
        	bar: {
          	pointWidth: 30,
          }
        },
        series: [
          {
            colorByPoint: true,
            colors: ['#428bca', '#428bca', '#428bca', '#5cb85c', '#5cb85c', '#5cb85c', '#5bc0de', '#5bc0de', '#5bc0de', '#d9534f', '#d9534f', '#d9534f'],
            name: "You",
            data: [self_awareness, intentional_learner, communication, relationship_development, diversity_difference, engaging_leadership, directive_leadership, champions, problem_solving, strategic_perspective, ethics_integrity, innovative_spirit]
          }
        ]
      } )
    end

    def sorted_graph_options
      array = []
      names = []
      competencies.each do |comp|
        names.push(comp[:competency])
        array.push(comp[:value])
      end
      Volt::Model.new( {
        id: 'sorted_bar_chart',
        mode: :chart,
        chart: {
          type: 'bar',
          renderTo: 'sorted_bar_chart',
          height: 500
        },
        title: {
          text: 'Ranked Competencies'
        },
        xAxis: {
          categories: names
        },
        yAxis: {
          title: {
              text: 'Score %',
          },
          max: 100
        },
        plotOptions: {
        	bar: {
          	pointWidth: 30,
          }
        },
        series: [
          {
            units: '%',
            colorByPoint: true,
            colors: ['#428bca', '#428bca', '#5cb85c', '#5cb85c', '#5cb85c', '#5cb85c', '#5cb85c', '#5cb85c', '#5cb85c', '#5cb85c', '#d9534f', '#d9534f'],
            name: "You",
            data: array
          }
        ]
      } )
    end

    def focus_area_options
      Volt::Model.new( {

        # identity the chart in volt
        id: 'focus_bar_chart',

        mode: :chart,

        # highcharts options
        chart: {
          type: 'bar',
          renderTo: 'focus_bar_chart',
          height: 400
        },
        title: {
          text: 'Competencies By Focus Area'
        },
        xAxis: {
          categories: ['Personal Leadership', 'Relational Leadership', 'Functional Leadership', 'Leading In Context']
        },
        yAxis: {
          title: {
              text: 'Score %',
          },
          max: 100
        },
        plotOptions: {
        	bar: {
          	pointWidth: 30,
          }
        },
        series: [
          {
            units: '%',
            colorByPoint: true,
            colors: ['#428bca', '#5cb85c', '#5bc0de', '#d9534f'],
            name: "You",
            data: [personal_leadership, relational_leadership, functional_leadership, leading_in_context]
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
      Volt.current_user.visible
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

    ######################
    #  Good Leader
    ######################
    def good_self_awareness
      sum = _q12_0_a.to_i + _q12_1_a.to_i + _q12_2_a.to_i + _q12_3_a.to_i + _q12_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_intentional_learner
      sum = _q13_0_a.to_i + _q13_1_a.to_i + _q13_2_a.to_i + _q13_3_a.to_i + _q13_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_communication
      sum = _q12_4_a.to_i + _q13_4_a.to_i + _q14_4_a.to_i + _q16_4_a.to_i + _q22_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_relationship_development
      sum = _q14_0_a.to_i + _q14_1_a.to_i + _q14_2_a.to_i + _q14_3_a.to_i + _q14_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_diversity_difference
      sum = _q15_0_a.to_i + _q15_1_a.to_i + _q15_2_a.to_i + _q15_3_a.to_i + _q15_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_engaging_leadership
      sum = _q16_0_a.to_i + _q16_1_a.to_i + _q16_2_a.to_i + _q16_3_a.to_i + _q16_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_directive_leadership
      sum = _q22_0_a.to_i + _q22_1_a.to_i + _q22_2_a.to_i + _q22_3_a.to_i + _q22_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_champions
      sum = _q17_0_a.to_i + _q17_1_a.to_i + _q17_2_a.to_i + _q17_3_a.to_i + _q17_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_problem_solving
      sum = _q18_0_a.to_i + _q18_1_a.to_i + _q18_2_a.to_i + _q18_3_a.to_i + _q18_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_strategic_perspective
      sum = _q19_0_a.to_i + _q19_1_a.to_i + _q19_2_a.to_i + _q19_3_a.to_i + _q19_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_ethics_integrity
      sum = _q20_0_a.to_i + _q20_1_a.to_i + _q20_2_a.to_i + _q20_3_a.to_i + _q20_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    def good_innovative_spirit
      sum = _q21_0_a.to_i + _q21_1_a.to_i + _q21_2_a.to_i + _q21_3_a.to_i + _q21_4_a.to_i
      ((sum / 20) * 100).round(2)
    end

    ######################
    #  Bad Leader
    ######################
    def bad_self_awareness
      sum = _q12_0_b.to_i + _q12_1_b.to_i + _q12_2_b.to_i + _q12_3_b.to_i + _q12_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_intentional_learner
      sum = _q13_0_b.to_i + _q13_1_b.to_i + _q13_2_b.to_i + _q13_3_b.to_i + _q13_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_communication
      sum = _q12_4_b.to_i + _q13_4_b.to_i + _q14_4_b.to_i + _q16_4_b.to_i + _q22_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_relationship_development
      sum = _q14_0_b.to_i + _q14_1_b.to_i + _q14_2_b.to_i + _q14_3_b.to_i + _q14_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_diversity_difference
      sum = _q15_0_b.to_i + _q15_1_b.to_i + _q15_2_b.to_i + _q15_3_b.to_i + _q15_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_engaging_leadership
      sum = _q16_0_b.to_i + _q16_1_b.to_i + _q16_2_b.to_i + _q16_3_b.to_i + _q16_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_directive_leadership
      sum = _q22_0_b.to_i + _q22_1_b.to_i + _q22_2_b.to_i + _q22_3_b.to_i + _q22_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_champions
      sum = _q17_0_b.to_i + _q17_1_b.to_i + _q17_2_b.to_i + _q17_3_b.to_i + _q17_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_problem_solving
      sum = _q18_0_b.to_i + _q18_1_b.to_i + _q18_2_b.to_i + _q18_3_b.to_i + _q18_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_strategic_perspective
      sum = _q19_0_b.to_i + _q19_1_b.to_i + _q19_2_b.to_i + _q19_3_b.to_i + _q19_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_ethics_integrity
      sum = _q20_0_b.to_i + _q20_1_b.to_i + _q20_2_b.to_i + _q20_3_b.to_i + _q20_4_b.to_i
      ((sum / 20) * 100).round(2)
    end

    def bad_innovative_spirit
      sum = _q21_0_b.to_i + _q21_1_b.to_i + _q21_2_b.to_i + _q21_3_b.to_i + _q21_4_b.to_i
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
      comp << {competency: "Ethics and Integrity", value: ethics_integrity}
      comp << {competency: "Strategic Perspective", value: strategic_perspective}
      comp << {competency: "Problem Solving", value: problem_solving}
      comp << {competency: "Champions Effective Processes", value: champions}
      comp << {competency: "Directive Leadership", value: directive_leadership}
      comp << {competency: "Engaging Leadership", value: engaging_leadership}
      comp << {competency: "Diversity and Difference", value: diversity_difference}
      comp << {competency: "Develops Relationships", value: relationship_development}
      comp << {competency: "Communicates Effectively", value: communication}
      comp << {competency: "Intentional Learner", value: intentional_learner}
      comp << {competency: "Self Aware", value: self_awareness}
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
