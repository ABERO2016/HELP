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

  field :good_leader, String
  field :bad_leader, String
  field :comps_chosen
  field :competency_one, String
  field :competency_two, String

  # Self-Awareness
  field :q12_0_a, Numeric
  field :q12_0_b, Numeric
  field :q12_0_c, Numeric
  field :q12_1_a, Numeric
  field :q12_1_b, Numeric
  field :q12_1_c, Numeric
  field :q12_2_a, Numeric
  field :q12_2_b, Numeric
  field :q12_2_c, Numeric
  field :q12_3_a, Numeric
  field :q12_3_b, Numeric
  field :q12_3_c, Numeric
  field :q12_4_a, Numeric
  field :q12_4_b, Numeric
  field :q12_4_c, Numeric

  # Intentional Learner
  field :q13_0_a, Numeric
  field :q13_0_b, Numeric
  field :q13_0_c, Numeric
  field :q13_1_a, Numeric
  field :q13_1_b, Numeric
  field :q13_1_c, Numeric
  field :q13_2_a, Numeric
  field :q13_2_b, Numeric
  field :q13_2_c, Numeric
  field :q13_3_a, Numeric
  field :q13_3_b, Numeric
  field :q13_3_c, Numeric
  field :q13_4_a, Numeric
  field :q13_4_b, Numeric
  field :q13_4_c, Numeric

  # Relationship Development
  field :q14_0_a, Numeric
  field :q14_0_b, Numeric
  field :q14_0_c, Numeric
  field :q14_1_a, Numeric
  field :q14_1_b, Numeric
  field :q14_1_c, Numeric
  field :q14_2_a, Numeric
  field :q14_2_b, Numeric
  field :q14_2_c, Numeric
  field :q14_3_a, Numeric
  field :q14_3_b, Numeric
  field :q14_3_c, Numeric
  field :q14_4_a, Numeric
  field :q14_4_b, Numeric
  field :q14_4_c, Numeric

  # Diversity and Difference
  field :q15_0_a, Numeric
  field :q15_0_b, Numeric
  field :q15_0_c, Numeric
  field :q15_1_a, Numeric
  field :q15_1_b, Numeric
  field :q15_1_c, Numeric
  field :q15_2_a, Numeric
  field :q15_2_b, Numeric
  field :q15_2_c, Numeric
  field :q15_3_a, Numeric
  field :q15_3_b, Numeric
  field :q15_3_c, Numeric
  field :q15_4_a, Numeric
  field :q15_4_b, Numeric
  field :q15_4_c, Numeric

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

  validate :good_leader, presence: true
  validate :bad_leader, presence: true
  validate :competency_one, presence: true
  validate :competency_two, presence: true

end
