require 'sqlite3'
require 'socket'
require 'timeout'

def getName(db,id)
  name = db.execute( "select name from student where id = '" + id.to_s + " '" )
  return name[0][0]
end

def getId(db,name)
  id = db.execute "select id from student where name="+name
  id = id[0][0]
  return id
end

def checkLoginStudent(db,name,pass)
  localPass = db.execute("select password from student where name =" + name)
  localPass = localPass[0][0]
  if localPass == pass
    return true
  else
    return false
  end
end

def checkLoginAdmin(db,name,pass)
  localPass = db.execute "select password from admin where name = " +name
  localPass = localPass[0][0]
  if localPass == pass
    return true
  else
    return false
  end
end

def addStudent(db,name,pass)
  p db
  studentId = (db.execute "select count(id) from student")[0][0]
  p studentId
  db.execute "insert into student values(#{studentId+1}, '#{name}', '#{pass}','','','')"
end

def getQuizName(db,id)
  return (db.execute "select name from quiz where id=#{id}")[0][0]
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
    quiz.push(partial)
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

def getAvailableQuizesForId(db, id)
  result = (db.execute "select availablequizes from student where id=#{id}")[0][0]
  unless result == nil then
    return result.split(" ")
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

def getPointsForQuestionWithId(dbquestion, id)
    (dbquestion.execute "select points from question where id=#{id}")[0][0]
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