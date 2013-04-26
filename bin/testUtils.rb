require '../lib/utils.rb'

begin
  systemInit('localhost',2000)
  quiz = SQLite3::Database.open 'Quiz.db'
  question = SQLite3::Database.open 'Question.db'
  student = SQLite3::Database.open 'Student.db'
  admin = SQLite3::Database.open 'Admin.db'

   #p  getAvailableQuizesForId(student,quiz,3)
    #deleteQuizWithId(quiz,student,question,1)
    #deleteAllQuizzes(quiz,student)
    #p [1,2,3,4].index(4)
   #p rescaleQuizForStudentId(student,1,33,20)
    #rescaleQuizId(quiz,student,2,4)
   #p  quizDataForStudentId(student, quiz,1)
   #quizesForStudent(student,quiz,2)
  #submitQuiz(student, 4, 3, 2, "da")

  #addQuiz(quiz,student,"vlad","1 2 3")

#addQuestion(question,"vlad",1,"vlad//vlad//vlad","vlad",23)
    #getQuizInfo(student,quiz,2)
    #quizDataForStudentId(student,2,1)
   # getQuizzesTaken(student,quiz,4)
    #p getDatesForStudentId(student,4)
   #p submitQuiz(student, 4, 1, 100,"11.03.2013")
   #p   getStudentsAvgGradeForQuizId(student,3)
  #p getFullQuizzes(quiz, student)
 # p getStudentNrWithQuizId(student,4)
  # addStudent(student, quiz, "filip", "fp", "fp")
  #p getFullStudents(student)
  #deleteAllStudents(student)
  #getLatestQuizzes(quiz,3)
  #p getAdminNameByUsername(admin,"test")
  #p checkLoginAdmin(admin, "test","test")
  #p checkLoginStudent(student,"alexuser","alexpass")
  #p getAvailableQuizesForId(student,quiz,getId(student,'alexuser'))
  #p getQuizIdForName(quiz,"historyQuiz")
  #p getQuizzesTaken(student,quiz,1).size
  #p getStudentNameByUsername(student,'alexuser')
  #  removeQuestionWithId(question, quiz, 2)
  #  addStudent(student,"Alex","alexpass")
  #  addStudent(student,"Vlad","vladpass")
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
  #p getQuestionsForQuizWithId(quiz,2)
  #getPointsForQuestionWithId(question,2)
  # p getFullQuestionsForQuizWithId(quiz,question,1)
rescue SQLite3::Exception => e

  puts "Exception occured"
  puts e

ensure
  quiz.close if quiz
  question.close if question
  student.close if student


end