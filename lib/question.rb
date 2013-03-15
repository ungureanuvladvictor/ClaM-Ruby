class Question
  attr_accessor :id
  attr_accessor :question
  attr_accessor :input
  attr_accessor :answer

  def initialize(*args)
    @id = args[0] unless args[0].nil?
    @question = args[1] unless args[1].nil?
    @input = args[2] unless args[2].nil?
    @answer = args[3] unless args[3].nil?
  end

  def setID(id)
    @id = id
  end

  def getID()
    @id
  end

  def setQuestion(question)
    @question =  question
  end

  def getQuestion()
    @question
  end

  def setInput(input)
    @input = input
  end

  def getInput()
    @input
  end

  def setAnswer(answer)
    @answer = answer
  end

  def getAnswer()
    @answer
  end

  def verifAnswer(ans)
    b = ans.split(" ")
    b.to_set == @answer.to_set
  end
end