class Competency < Volt::Model
  belongs_to :club

  field :name
  field :description

  validate :name, presence: true
end
