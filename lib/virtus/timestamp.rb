class Timestamp < Virtus::Attribute
  def coerce(value)
    case value
    when Fixnum
      Time.at(value)
    when Time
      value
    else
      raise ArgumentError.new("#{value.class} cannot be coerced to Time")
    end
  end
end