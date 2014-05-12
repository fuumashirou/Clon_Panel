class HappyHour
  include Mongoid::Document
  embedded_in :store
  embeds_one :rules, class_name: "HhRules"
  embeds_one :schedules, class_name: "HhSchedules"

  field :active, type: Mongoid::Boolean, default: true

  before_save :complete

  accepts_nested_attributes_for :schedules
  accepts_nested_attributes_for :rules

  def complete
    Schedule::DAYS_OF_THE_WEEK.each do |day|
      self.schedules[day]["active"]  = self.schedules[day]["active"]  == "true" ? true : false
      self.schedules[day]["all_day"] = self.schedules[day]["all_day"] == "true" ? true : false
      if self.schedules[day]["all_day"]
        self.schedules[day]["start_time"] = nil
        self.schedules[day]["end_time"]   = nil
      else
        self.schedules[day]["start_time"] = Chronic.parse(self.schedules[day]["start_time"]).nil? ? nil : Chronic.parse(self.schedules[day]["start_time"]).seconds_since_midnight.to_i
        self.schedules[day]["end_time"]   = Chronic.parse(self.schedules[day]["end_time"]).nil? ? nil : Chronic.parse(self.schedules[day]["end_time"]).seconds_since_midnight.to_i
      end
    end
  end
end
