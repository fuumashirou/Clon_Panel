module HappyHoursHelper

  def seconds_to_time seconds_since_midnight, format
    unless seconds_since_midnight.nil?
      if format == :time
        return (Time.current.midnight + seconds_since_midnight.to_f).strftime("%I:%M%P")
      else
        return Time.current.midnight + seconds_since_midnight.to_f
      end
    end
  end

end
