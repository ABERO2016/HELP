class SurveyForm < Volt::Model
  belongs_to :user

  # knowing how to reach goals
  field :q9_0, Numeric
  field :q9_1, Numeric
  field :q9_2, Numeric
  field :q9_3, Numeric

  # transitioning to major/uni/eng
  field :q10_0, Numeric
  field :q10_1, Numeric
  field :q10_2, Numeric
  field :q10_3, Numeric
  field :q10_4, Numeric

  field :how_hart
  field :good_leader, String
  field :bad_leader, String

  # Self-Awareness
  field :q12_0, Numeric
  field :q12_1, Numeric
  field :q12_2, Numeric
  field :q12_3, Numeric
  field :q12_4, Numeric

  # Intentional Learner
  field :q13_0, Numeric
  field :q13_1, Numeric
  field :q13_2, Numeric
  field :q13_3, Numeric
  field :q13_4, Numeric

  # Relationship Development
  field :q14_0, Numeric
  field :q14_1, Numeric
  field :q14_2, Numeric
  field :q14_3, Numeric
  field :q14_4, Numeric

  # Diversity and Difference
  field :q15_0, Numeric
  field :q15_1, Numeric
  field :q15_2, Numeric
  field :q15_3, Numeric
  field :q15_4, Numeric

  # Engaging Leadership
  field :q16_0, Numeric
  field :q16_1, Numeric
  field :q16_2, Numeric
  field :q16_3, Numeric
  field :q16_4, Numeric

  # Directive Leadership
  field :q17_0, Numeric
  field :q17_1, Numeric
  field :q17_2, Numeric
  field :q17_3, Numeric
  field :q17_4, Numeric

  # Champions Effective Processes
  field :q18_0, Numeric
  field :q18_1, Numeric
  field :q18_2, Numeric
  field :q18_3, Numeric
  field :q18_4, Numeric

  # Problem Solving
  field :q19_0, Numeric
  field :q19_1, Numeric
  field :q19_2, Numeric
  field :q19_3, Numeric
  field :q19_4, Numeric

  # Strategic Perspective
  field :q20_0, Numeric
  field :q20_1, Numeric
  field :q20_2, Numeric
  field :q20_3, Numeric
  field :q20_4, Numeric

  # Ethics and Integrity
  field :q21_0, Numeric
  field :q21_1, Numeric
  field :q21_2, Numeric
  field :q21_3, Numeric
  field :q21_4, Numeric

  # Innovative Spirit
  field :q22_0, Numeric
  field :q22_1, Numeric
  field :q22_2, Numeric
  field :q22_3, Numeric
  field :q22_4, Numeric

end
