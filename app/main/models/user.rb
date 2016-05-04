# By default Volt generates this User model which inherits from Volt::User,
# you can rename this if you want.
class User < Volt::User
  # login_field is set to :email by default and can be changed to :username
  # in config/app.rb
  ROLES = ['Student', 'Admin']
  MAJORS_OPTIONS = ['', 'Civil Engineering', 'Computer Engineering', 'Computer Science', 'Electrical Engineering', 'Engineering', 'Engineering Management Information Systems', 'Environmental Engineering','Management Science', 'Mechanical Engineering', 'Other']
  MAJORS = ['Civil Engineering', 'Computer Engineering', 'Computer Science', 'Electrical Engineering', 'Engineering', 'Engineering Management Information Systems', 'Environmental Engineering','Management Science', 'Mechanical Engineering', 'Other']
  SURVEY_STATUS = ['not taken', 'in progress', 'taken']
  COMPETENCIES = ['Self Aware', 'Intentional Learner', 'Communicates Effectively', 'Develops Relationships', 'Diversity and Difference', 'Engaging Leadership', 'Directive Leadership', 'Champions Effective Processes', 'Problem Solving', 'Strategic Perspective', 'Ethics and Integrity', 'Innovative Spirit']

  field login_field
  field :first_name
  field :last_name
  field :smu_id
  field :prefered_name
  field :last_login
  field :graduation_year
  field :major, String
  field :other_major, String
  field :role
  field :survey_status
  field :mktg, String
  field :visible

  #Validations
  validate login_field, unique: true, length: 8, presence: true
  validate :smu_id, unique: true, length: 8, presence: true
  validate :graduation_year, length: 4, presence: true
  validate :major, format: { with: -> (major) { MAJORS.include?(major) }, message: "must be one of #{MAJORS.join(', ')}" }
  validate :first_name, presence: true
  validate :last_name, presence: true
  validate :role, format: { with: -> (role) { ROLES.include?(role) }, message: "must be one of #{ROLES.join(', ')}" }
  validate :survey_status, format: { with: -> (role) { SURVEY_STATUS.include?(role) }, message: "must be one of #{SURVEY_STATUS.join(', ')}" }

  def name
    name_missing = [first_name, last_name].compact.empty?
    name_missing ? email : "#{first_name} #{last_name}"
  end

  def admin?
    role == 'Admin'
  end

  def survey_taken?
    if survey_status == 'taken'
      true
    else
      false
    end
  end
end
