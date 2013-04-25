require '../lib/utils.rb'

begin
  systemInit('localhost',2000)
  quiz = SQLite3::Database.open 'Quiz.db'
  question = SQLite3::Database.open 'Question.db'
  student = SQLite3::Database.open 'Student.db'
  admin = SQLite3::Database.open 'Admin.db'

  #p checkLoginAdmin(admin, "test","test")
  p checkLoginStudent(student,"alexuser","alexpass")
  p getAvailableQuizesForId(student,quiz,getId(student,'alexuser'))
  p getQuizIdForName(quiz,"firstQuiz")

  #removeQuestionWithId(question, quiz, 2)
  #  #addStudent(student,"Alex","alexpass")
  #addStudent(student,"Vlad","vladpass")
  #p getQuizesForId(student,1)
  #p getAvailableQuizesForId(student,1)
  #p getQuizName(quiz,1)
  #p getQuizzesTaken(student,quiz,1)
  #p addQuiz(quiz,"historyQuiz","1 2 3")
  #p addQuestion(question,"What is the height of the Everest?", 1, "123 meters±431 meters±-321 meters", "123 meters")
  #p checkAnswerForQuestionWithId(question,6,"123 meters")
  #p getPointsForQuizWithId(quiz,question,3)
  #  removeQuizWithId(student,quiz,2)
  #  systemInit('localhost',2000)
  #  executeStudentUpdate('localhost', 2000, "update student set name='andrei' where id=3")

rescue SQLite3::Exception => e

  puts "Exception occured"
  puts e

ensure
  quiz.close if quiz
  question.close if question
  student.close if student


end