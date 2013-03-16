require '../lib/error'
require '../lib/grade'
require '../lib/question'
require '../lib/quiz'
require '../lib/Student'
require '../lib/professor'
require 'xml-simple'

e = Error.new("../log/log.txt")
quizFile = File.open("../quizzes/quizzes.xml",'r')
fileContent = quizFile.read

import = XmlSimple.xml_in(fileContent, { 'KeyAttr' => 'name' })

newQuiz = Quiz.new(nil,nil,nil,nil)
newQuiz.setID(import['id'])
newQuiz.setTitle(import['title'])
newQuiz.setGrade(import['grade'])

questions = Array.new

for i in 1..import['Questions'][0].size do
  question = Question.new
  question.id  = import['Questions'][0]['Q'+i.to_s][0]['id']
  question.question = import['Questions'][0]['Q'+i.to_s][0]['question']
  question.answer = import['Questions'][0]['Q'+i.to_s][0]['answer']
  question.input = import['Questions'][0]['Q'+i.to_s][0]['input']
  questions<<question
end

newQuiz.question = questions


puts "\nWhat is your name, student?"

name = gets.chomp


for i in 0...newQuiz.question.size
  puts newQuiz.question[i].question
  for j in 0...newQuiz.question[i].input.size
    print j+1
    print ". "
    puts newQuiz.question[i].input[j]
  end
  print "\nYour answer: "
  answer = gets.chomp
  newQuiz.grade.value = 1 + newQuiz.grade.value.to_i if answer.downcase == newQuiz.question[i].answer.downcase
  puts
end

e.log("Student "+ name + " scored " + newQuiz.getGrade.to_s + " in the quiz on the topic " + newQuiz.title + ".")

puts "Your score is: " + newQuiz.getGrade.to_s


=begin
export = Hash.new()
intrebari = Hash.new

export['id'] = q.id
export['title'] = q.title
export['grade'] = q.getGrade.to_s

for i in 0...q.question.size
  intrebare = Hash.new
  intrebare['id'] = q.question[i].id
  intrebare['question'] = q.question[i].question
  intrebare['input'] = q.question[i].input
  intrebare['answer']  = q.question[i].answer
  intrebari["Q" + q.question[i].id.to_s] = intrebare
end

export['Questions'] = intrebari

File.open("../quizzes/quizzes.xml",'w') {|f|
f.write(XmlSimple.xml_out(export))}
=end
