require '../lib/question.rb'
require '../lib/grade.rb'

class Quiz
  attr_accessor :id
  attr_accessor :title
  attr_accessor :question
  attr_accessor :grade

  def initialize(id, title, question, grade)
    @grade = Grade.new()
    @question = Question.new()
    @grade.value=grade unless grade.nil?
    @question = question unless question.nil?
    @id = id
    @title = title
  end

  def setID(id)
    @id = id
  end

  def getID()
    @id
  end

  def setTitle(title)
    @title = title
  end

  def getTitle()
    @title
  end

  def setQuestions(questions)
    @question = question
  end

  def getQuestions()
    @question
  end

  def setGrade(grade)
    @grade.setGrade(grade)
  end

  def getGrade()
    @grade.getGrade()
  end

end