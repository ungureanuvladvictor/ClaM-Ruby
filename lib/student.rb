require '../lib/quiz.rb'

class Student
  attr_accessor :username
  attr_accessor :password
  attr_accessor :ID
  attr_accessor :name
  attr_accessor :quizzesTaken

  def initialize(*args)
    @username = args[0] unless args[0].nil?
    @password = args[1] unless args[1].nil?
    @ID = args[2] unless args[2].nil?
    @name = args[3] unless args[3].nil?
    @quizzesTaken = args[4] unless args[4].nil?
  end

  def getID()
    @ID
  end

  def getUsername()
    @username
  end

  def getPassword()
    @password
  end

  def getName()
    @name
  end

  def getQuizzes()
    @quizzesTaken
  end

  def setUsername(username)
    @username = username
  end

  def setPassword(password)
    @password = password
  end

  def setID(id)
    @ID = id
  end

  def setName(name)
    @name = name
  end

end