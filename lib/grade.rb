class Grade
  attr_accessor :value

  def initialize(*args)
    @value = args[0] unless args[0].nil?
  end

  def setGrade(value)
    @value = value
  end

  def getGrade
    @value
  end

end