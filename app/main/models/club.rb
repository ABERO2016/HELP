class Club < Volt::Model
  field :name, String
  field :description
  field :more_info

  validate :name, presence: true
end
