require "../lib/quiz.rb"

class Professor
  attr_accessor :ID
  attr_accessor :username
  attr_accessor :password
  attr_accessor :name

  def initialize(*args)
    @ID = args[0] unless args[0].nil?
    @username = args[1] unless args[1].nil?
    @password = args[2] unless args[2].nil?
    @name = args[3] unless args[3].nil?
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

  def setID(id)
    @ID=id
  end

  def setUsername(username)
    @username=username
  end

  def setPassword(password)
    @password=password
  end

  def setName(name)
    @name=name
  end

  def ImportQuizzes(f)

  end

  def ImportStudents(f)

  end

end