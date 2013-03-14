require '../lib/error'
require '../lib/grade'
require '../lib/question'
require '../lib/quiz'

er = Error.new("error.txt")
er.log("debug")

gr = Grade.new(1212)
puts gr.getGrade

q = Question.new(1,"ce",[1,2,3],[2,3])
puts q.getInput
print q.getAnswer

z = Question.new()
puts z.getInput

quiz = Quiz.new(1,"Test",q,gr)

print quiz.getGrade
print quiz.getQuestions