class Event < Volt::Model
  field :name, String
  field :description
  field :date
  field :start_time
  field :end_time
  field :location


  validate :name, presence: true
  validate :date, presence: true
  validate :start_time, presence: true

end
