require '../lib/error'
require '../lib/question'
require '../lib/quiz'
require '../lib/student'
require '../lib/AESCrypt'
require 'digest/sha1'
require 'sqlite3'
require 'xmlsimple'

key = '12345678912345678912345678912345'

e = Error.new('../log/log.txt')

quizFile = File.open('../quizzes/quizzez.xml','r')
fileContent = AESCrypt.decrypt(quizFile.read,key,nil,"AES-256-CBC")
#import quiz
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
  questions << question
end

newQuiz.question = questions
newQuiz2 = newQuiz
newQuiz2.id = 2
#export quiz
=begin
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
 =end
=begin
export = Hash.new()
expQuest = Hash.new

export['id'] = newQuiz.id
export['title'] = newQuiz.title
export['grade'] = newQuiz.getGrade.to_s

for i in 0...newQuiz.question.size
  quest = Hash.new
  quest['id'] = newQuiz.question[i].id
  quest['question'] = newQuiz.question[i].question
  quest['input'] = newQuiz.question[i].input
  quest['answer']  = newQuiz.question[i].answer
  expQuest["Q" + newQuiz.question[i].id.to_s] = quest
end

export['Questions'] = expQuest

File.open("../quizzes/quizzez.xml",'w') {|f|
  stuffToExport = XmlSimple.xml_out(export)
  f.write(AESCrypt.encrypt(stuffToExport,key,nil,"AES-256-CBC"))
}
=end

vlad = Student.new(nil,nil,nil,nil,nil)
vlad.setID(3)
vlad.setName('vlad')
vlad.setUsername('vlad')
vlad.setPassword(Digest::SHA1.hexdigest 'vlad')
arr = [newQuiz,newQuiz2]

vlad.quizzesTaken = arr
p vlad
