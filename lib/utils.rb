require '../lib/cheat_algorithm'
require 'sqlite3'
require 'socket'
require 'timeout'


def getStudentNameByUsername(db, username)
  return (db.execute "select name from student where username='#{username}'")[0][0]
end

def getAdminNameByUsername(db, username)
    return (db.execute "select name from admin where username='#{username}'")[0][0]
end

def getId(db,name)
  id = db.execute "select id from student where username='#{name}'"
  id = id[0][0]
  return id
end

def checkLoginStudent(db,name,pass)
  localPass = db.execute "select pass from student where username ='#{name}'"
  p name
  if localPass == []
    return false
  elsif
  localPass = localPass[0][0]
    if localPass == pass
      return true
    else
      return false
    end
  end
end

def checkLoginAdmin(db,name,pass)
  localPass = db.execute "select pass from admin where username ='#{name}'"
  if localPass == []
    return false
  elsif
    localPass = localPass[0][0]
    if localPass == pass
      return true
    else
      return false
    end
  end
end

def addStudent(dbstudent, dbquiz, name, username, pass)
  result = (dbstudent.execute "select max(id) from student")
  if result[0][0] == nil
    studentId = 0
  else
    studentId = result[0][0]
  end
  quizzes = (dbquiz.execute "select id from quiz")
  finalQuizzes = Array.new
  quizzes.each do |quizId|
    finalQuizzes.push(quizId[0])
  end
  dbstudent.execute "insert into student values(#{studentId+1}, '#{name}', '#{pass}', '', '#{finalQuizzes.join(" ")}', '','#{username}')"
  return "insert into student values(#{studentId+1}, '#{name}', '#{pass}', '', '#{finalQuizzes.join(" ")}', '','#{username}')"
end

def getQuizName(db,id)
  return (db.execute "select name from quiz where id=#{id}")[0][0]
end

def getQuizIdForName(db, name)
  result = (db.execute "select id from quiz where name='#{name}'")
  if result == []
    return 0
  else
    return result[0][0]
  end
end

def getQuizzesTaken(dbstudent, dbquiz, id)
  quiz = Array.new
  quizzNames = Array.new
  quizzScores = Array.new
  quizzDates = getDatesForStudentId(dbstudent,id)

  quizzesId = getQuizesForStudentId(dbstudent,id)
  getScoresForStundetId(dbstudent,id).each do |tuple|
    quizzScores.push((tuple.split(" "))[1])
  end
   quizzesId.each do |idQuiz|
    quizzNames.push(getQuizName(dbquiz,idQuiz))
  end

  for i in 0...quizzScores.size
    partial = String.new
    partial += (i+1).to_s
    partial += " "
    partial += quizzNames[i].to_s
    partial += " "
    partial += quizzDates[i].to_s
    partial += " "
    partial += quizzScores[i].to_s
    quiz.push(partial.split(" "))
  end
  quiz
end

def getScoresForStundetId(db,id)
  (db.execute "select scores from student where id=#{id}")[0][0].split(",")
end

def getDatesForStudentId(db,id)
  (db.execute "select dates from student where id=#{id}")[0][0].split(",")
end

def getQuizesForStudentId(db,id)
  quizList = Array.new
  quizes = (db.execute "select scores from student where id=#{id}")[0][0].split(",")

  quizes.each do |quiz|
    quizId = quiz.split(" ")
    quizList.push(quizId[0])
  end
   quizList
end

def getAvailableQuizesForId(dbStudent, dbQuiz, id)
  names = Array.new
  result = (dbStudent.execute "select availablequizes from student where id=#{id}")[0][0]
  unless result == nil then
    partial = result.split(" ")
    partial.each do |j|
      names.push(getQuizName(dbQuiz, j.to_i))
    end
    return names
  else
    return []
  end
end

def setAvailableQuizesForId(db, id, quizes)
  db.execute "update student set availablequizes='#{quizes}' where id=#{id}"
end

def addQuiz(db, name, questions)
  id = (db.execute "select count(id) from quiz")[0][0]
  id +=1
  db.execute "insert into quiz values(#{id},'#{name}','#{questions}')"
end

def addQuestion(db, name, type, answers, correct, points)
  id = (db.execute "select count(id) from question")[0][0]
  id += 1
  db.execute "insert into question values(#{id}, '#{name}', #{type}, '#{answers}', '#{correct}', #{points})"
end

def checkAnswerForQuestionWithId(db, id, answer)
  if answer == (db.execute "select correct from question where id=#{id}")[0][0]
    true
  else
    false
  end
end

def removeQuizWithId(dbstudent, dbquiz, id)
    i = (dbstudent.execute "select count(id) from student")[0][0]
    for j in 1..3
      quizesUpdate = Array.new
      quizesNow = getAvailableQuizesForId(dbstudent,j)
      quizesNow.each do |x|
        if x.to_i!=id
          quizesUpdate.push(x)
        end
      end
      setAvailableQuizesForId(dbstudent,j,quizesUpdate.join(" "))
    end
    dbquiz.execute "delete from quiz where id=#{id}"
end

def removeQuestionWithId(dbquestion, dbquiz, id)
    countQuiz = (dbquiz.execute "select max(id) from quiz;")[0][0].to_i
    for i in 1..countQuiz do
      result = getQuestionsForQuizWithId(dbquiz, i)
      if !result.nil?
        partial = Array.new
        result.each do |j|
          if j.to_i!=id
            partial.push(j)
          end
        end
        setQuestionsForQuizWithId(dbquiz, partial.join(" "), i)
      end
    end
end

def setQuestionsForQuizWithId(dbquiz, questions, id)
    dbquiz.execute "update quiz set questions='#{questions}' where id=#{id};"
end

def getQuestionsForQuizWithId(dbquiz, id)
    result = (dbquiz.execute "select questions from quiz where id=#{id}")
    if result != []
      return result[0][0].split(" ")
    end
end

def getPointsForQuizWithId(dbquiz, dbquestion, id)
    totalPoints = 0
    questions = (dbquiz.execute "select questions from quiz where id=#{id}")[0][0].split(" ")
    questions.each do |question|
      if !getPointsForQuestionWithId(dbquestion,question.to_i).to_i.nil?
        totalPoints += getPointsForQuestionWithId(dbquestion,question.to_i).to_i
      end
    end
    return totalPoints
end

def setPointsForQuestionWithId(dbquestion, points, id)
    dbquestion.execute "update question set points=#{points} where id=#{id}"
end

def requestFile(address, port, file)
    sock = begin
      Timeout::timeout( 1 ) { TCPSocket.open( address, port ) }
    rescue StandardError, RuntimeError => ex
      raise "cannot connect to server: #{ex}"
    end

    sock.write( "#{file}\r\n" )
    response = begin
      Timeout::timeout(1) {
        sock.recv(10000000).chomp("\n")
      }
    rescue TimeoutError,StandardError, RuntimeError => ex
      raise "no response from server: #{ex}"
    end

    fileToWrite = File.open("#{file}", 'wb')
    fileToWrite.print(response)
    fileToWrite.close
    sock.close
end

def systemInit(address, port)
  requestFile(address, port, "Student.db")
  requestFile(address, port, "Question.db")
  requestFile(address, port, "Quiz.db")
  requestFile(address, port, "Admin.db")
end

def executeStudentUpdate(address, port, command)
  sock = begin
    Timeout::timeout( 1 ) { TCPSocket.open( address, port ) }
  rescue StandardError, RuntimeError => ex
    raise "cannot connect to server: #{ex}"
  end

  sock.write( "#{command}\r\n" )
  sock.close
end

def getFullQuestionsForQuizWithId(dbquiz, dbquestion, quizId)
    finalResult = Array.new
    questionIds = getQuestionsForQuizWithId(dbquiz, quizId)
    questionIds.each do |questionId|
      name = getNameOfQuestionWithId(dbquestion, questionId)
      type = getTypeOfQuestionWithId(dbquestion, questionId)
      correctAnswer = getCorrectAnswerOfQuestionWithId(dbquestion, questionId)
      answersPartial = getAnswersOfQuestionWithId(dbquestion, questionId).split("//")
      answers = answersPartial.map do |answer|
        answer.strip
      end
      points = getPointsForQuestionWithId(dbquestion, questionId)
      finalResult.push([name, points, type, correctAnswer, answers])
    end
    return finalResult
end

def getNameOfQuestionWithId(dbquestion, id)
    return (dbquestion.execute "select name from question where id=#{id}")[0][0]
end

def getTypeOfQuestionWithId(dbquestion, id)
    return (dbquestion.execute "select type from question where id=#{id}")[0][0]
end

def getCorrectAnswerOfQuestionWithId(dbquestion, id)
    return (dbquestion.execute "select correct from question where id=#{id}")[0][0]
end

def getAnswersOfQuestionWithId(dbquestion, id)
    return (dbquestion.execute "select answers from question where id=#{id}")[0][0]
end

def getPointsForQuestionWithId(dbquestion, id)
    return (dbquestion.execute "select points from question where id=#{id}")[0][0]
end

def getLatestQuizzes(db, number)
    result = Array.new
    array = (db.execute "select id from quiz order by id DESC limit #{number}")
    array.each do |quizId|
      name = getQuizName(db, quizId[0])
      result.push([quizId[0],name])
    end
    p result

end

def deleteAllStudents(db)
    db.execute "delete from student"
end

def getFullStudents(db)
    finalStudents = Array.new
    result = db.execute "select id, name, scores from student;"
    result.each do |student|
      id = student[0]
      name = student[1]
      quizzes = student[2].split(",")
      nr_quizzes = quizzes.size
      #p quizzes
      avg = 0
      quizzes.each do |quiz|
        avg = avg + quiz.split(" ")[1].to_i
      end
      if avg.nonzero?
        avg = avg/nr_quizzes
      else
        avg = '-'
        nr_quizzes = '-'
      end

      finalStudents.push([id,name,nr_quizzes,avg])
    end
    return finalStudents
end