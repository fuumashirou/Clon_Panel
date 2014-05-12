class Schedule
  include Mongoid::Document
  embedded_in :store

  DAYS_OF_THE_WEEK = %w(monday tuesday wednesday thursday friday saturday sunday)

  field :monday,    type: Hash
  field :tuesday,   type: Hash
  field :wednesday, type: Hash
  field :thursday,  type: Hash
  field :friday,    type: Hash
  field :saturday,  type: Hash
  field :sunday,    type: Hash

  before_save :complete

  def complete
    Schedule::DAYS_OF_THE_WEEK.each do |day|
      self[day]["active"]  = self[day]["active"]  == "true" ? true : false
      self[day]["all_day"] = self[day]["all_day"] == "true" ? true : false
      if self[day]["all_day"] == true
        self[day]["start_time"] = nil
        self[day]["end_time"]   = nil
      else
        self[day]["start_time"] = Chronic.parse(self[day]["start_time"]).nil? ? nil : Chronic.parse(self[day]["start_time"]).seconds_since_midnight.to_i
        self[day]["end_time"]   = Chronic.parse(self[day]["end_time"]).nil? ? nil : Chronic.parse(self[day]["end_time"]).seconds_since_midnight.to_i
      end
    end
  end

end
