require '../lib/error'
require '../lib/grade'
require '../lib/question'
require '../lib/quiz'
require '../lib/student'
require '../lib/professor'

a = Question.new(1, "someQuestion1 ?", ["answer", "anotherAnswer", "someRandomAnswer", "theCorrectAnswer"], "theCorrectAnswer")
b = Question.new(2, "someQuestion2 ?", ["pickMe", "no!PickMe", "randomAnswer"], "randomAnswer")
c = Question.new(3, "Who is from Macedonia ?", ["Vlad", "Dmitrii", "Filip"], "Filip")

q = Quiz.new(1,"randomQuiz",[a,b,c],0)

puts "\nLet us do the quiz for " + q.title + "\n\n"

for i in 0...q.question.size
  puts q.question[i].question
  for j in 0...q.question[i].input.size
    print j+1
    print ". "
    puts q.question[i].input[j]
  end
  print "\nYour answer: "
  answer = gets.chomp
  q.setGrade(1 + q.getGrade) if answer.downcase == q.question[i].answer.downcase
  puts
end

puts "Your score is: " + q.getGrade.to_s
