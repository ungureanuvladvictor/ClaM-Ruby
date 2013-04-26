require '../lib/cheat_algorithm'
require 'sqlite3'
require 'socket'
require 'timeout'

def getStudentNameById(db, id)
  return (db.execute "select name from student where id='#{id}'")[0][0]
end

def getAdminNameById(db, id)
  return (db.execute "select name from admin where id='#{id}'")[0][0]
end

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
  result = (db.execute "select name from quiz where id=#{id}")
  if result.nil? || result == "" || result == "nil"
    return []
  else
    result[0][0]
  end
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

  if quizzDates == [""]
    return []
  end
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
  result = (db.execute "select dates from student where id=#{id}")
  if result[0][0] == nil
    return [""]
  else
    result = result[0][0].split(",")
  end
  return result
end

def getQuizesForStudentId(db,id)
  quizList = Array.new
  result = db.execute "select scores from student where id=#{id}"
  if result[0][0] == nil
    return [""]
  else
    quizes = result[0][0].split(",")

  end

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

def addQuiz(db,studentdb, name, questions)
  id = (db.execute "select max(id) from quiz")[0][0]
  if id == nil
    id = 1
  else
    id = id + 1
  end
  db.execute "insert into quiz values(#{id},'#{name}','#{questions}')"
   result =  studentdb.execute "select id,availablequizes from student"
   result.each do |student|
     student[1] = student[1]+" #{id}"
     studentdb.execute "update student set availablequizes='#{student[1]}' where id=#{student[0]}"
     executeStudentUpdate('localhost',2000,"update student set availablequizes='#{student[1]}' where id=#{student[0]}")
   end
  return "insert into quiz values(#{id},'#{name}','#{questions}')"
end

def addQuestion(db, name, type, answers, correct, points)
  id = (db.execute "select max(id) from question")[0][0]
  if id == nil
    id = 1
  else
    id = id +1
  end
  db.execute "insert into question values(#{id}, '#{name}', #{type}, '#{answers}', '#{correct}', #{points})"
  return ["insert into question values(#{id}, '#{name}', #{type}, '#{answers}', '#{correct}', #{points})",id]
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
      return false
      #raise "cannot connect to server: #{ex}"
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
  return true
end

def systemInit(address, port)
  bool = Array.new
  bool.push requestFile(address, port, "Student.db")
  bool.push requestFile(address, port, "Question.db")
  bool.push requestFile(address, port, "Quiz.db")
  bool.push requestFile(address, port, "Admin.db")
  bool.each do |val|
    if val == false
      return false
    end
  end
  return true
end

def executeStudentUpdate(address, port, command)
  sock = begin
    Timeout::timeout( 1 ) { TCPSocket.open( address, port ) }
  rescue StandardError, RuntimeError => ex
    raise "cannot connect to server: #{ex}"
  end

  sock.write( "s #{command}\r\n" )
  sock.close
end

def executeQuestionUpdate(address, port, command)
  sock = begin
    Timeout::timeout( 1 ) { TCPSocket.open( address, port ) }
  rescue StandardError, RuntimeError => ex
    raise "cannot connect to server: #{ex}"
  end

  sock.write( "q #{command}\r\n" )
  sock.close
end

def executeQuizzUpdate(address, port, command)
  sock = begin
    Timeout::timeout( 1 ) { TCPSocket.open( address, port ) }
  rescue StandardError, RuntimeError => ex
    raise "cannot connect to server: #{ex}"
  end

  sock.write( "Q #{command}\r\n" )
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
      if student[2] != nil
        quizzes = student[2].split(",")
      else
        quizzes = []
      end
      nr_quizzes = quizzes.size
      #p quizzes
      avg = 0
      quizzes.each do |quiz|
        if quiz == nil
          grd =0
        else
          grd = quiz.split(" ")[1].to_i
        end
        avg = avg + grd
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

def getFullQuizzes(dbQuiz, dbStudent)
  finalQuiz = Array.new
  result = dbQuiz.execute "select id,name from quiz"
  if result == []
    return []
  end
  if result == nil
    return []
  end
  if result[0][0] == nil
    return []
  else
    result.each do |quiz|
      quizId = quiz[0]
      quizName = quiz[1]
      quizTaken = getStudentNrWithQuizId(dbStudent,quizId)
      quizAvg = getStudentsAvgGradeForQuizId(dbStudent,quizId)
      if quizTaken.to_i == 0
        quizTaken = "-"
        quizAvg = "-"
      end
      finalQuiz.push([quizId,quizName,quizTaken,quizAvg])
    end
  end
  return finalQuiz
end

def getStudentNrWithQuizId(dbStudent, quizId)
  number = 0
  me = Array.new
  result = dbStudent.execute "select scores from student"
  result.each do |test|
    if test != [nil]
        me.push(test)
    end
  end
  result = me
  if result[0][0] == nil
    return nil
  else
    scores = Array.new
    result.each do |score|
        scores.push(score[0])
    end
    scores.delete("")
    scores.each do |score|
      score.split(',').each do |quiz|
        if quiz.split(" ")[0] == quizId.to_s
          number = number +1
        end
      end
    end
  end
  return  number
end

def getStudentsAvgGradeForQuizId(dbStudent, quizId)
  number = 0
  avg = 0
  me = Array.new
  result = dbStudent.execute "select scores from student"
  result.each do |test|
    if test != [nil]
      me.push(test)
    end
  end
  result = me
  if result[0][0] == nil
    return nil
  else
    scores = Array.new
    result.each do |score|
      scores.push(score[0])
    end
    scores.delete("")
    scores.each do |score|
      score.split(',').each do |quiz|
        if quiz.split(" ")[0] == quizId.to_s
          number = number +1
          avg = avg + quiz.split(" ")[1].to_f
        end
      end
    end
  end
  if number.zero? || avg.zero?
    return 0
  else
    return (avg.to_f/number.to_f).to_s[0,5]
  end
end

def submitQuiz(dbStudent, studentId, quizId, quizResult, date)
    query = dbStudent.execute "select scores,dates,availablequizes from student where id=#{studentId}"
    quizzes = Array.new

    if query[0][0] == nil
      dbStudent.execute "update student set scores='#{quizId} #{quizResult},', dates='#{date},' where id=#{studentId}"
      finalQuizzes = Array.new
      availableQuizes = query[0][2].split(" ")
      p availableQuizes

      availableQuizes.each do |quiz|
        if quiz!=quizId.to_s
          finalQuizzes.push(quiz)
        end
      end
      finalQuizzes = finalQuizzes.join(" ")
      dbStudent.execute "update student set scores='#{quizId} #{quizResult},', dates='#{date},',  availablequizes='#{finalQuizzes}' where id=#{studentId}"
      return "update student set scores='#{quizId} #{quizResult},', dates='#{date},',  availablequizes='#{finalQuizzes}' where id=#{studentId}"
    else
      localScores = query[0][0].split","
      localScores.push("#{quizId} #{quizResult}")
      localScores = localScores.join(",")
      dates = query[0][1].split","
      dates.push(date)
      dates = dates.join(",")
      finalQuizzes = Array.new
      availableQuizes = query[0][2].split(" ")
      availableQuizes.each do |quiz|
        if quiz!=quizId.to_s
          finalQuizzes.push(quiz)
        end
      end
      finalQuizzes = finalQuizzes.join(" ")
      dbStudent.execute "update student set scores='#{localScores},', dates='#{dates}', availablequizes='#{finalQuizzes}' where id=#{studentId}"
    end
  return "update student set scores='#{localScores},', dates='#{dates},', availablequizes='#{finalQuizzes}' where id=#{studentId}"
end

def getQuizInfo(dbStudent, dbQuiz, quizId)
    finalResult = Array.new
    studentIds = dbStudent.execute "select id from student"
    studentIds.each do |student|
      student = student[0]
      result = magic(dbStudent,quizId,student)
      if result != []
        finalResult.push(result)
        end
    end
    p finalResult
end

def magic(dbStudent, quizId, studentId)
  finalResult = Array.new
  result = dbStudent.execute "select scores,dates,name from student where id=#{studentId}"
  if result[0][0] == nil
    return []
  end
  scores = result[0][0].split","
  dates = result[0][1].split","
  name = result[0][2]
  i = 0
  scores.each do |quiz|
    id = quiz.split(" ")
    if id[0].to_s == quizId.to_s
      finalResult.push(studentId,name,dates[i],id[1])
    end
    i = i+1
  end
  return finalResult
end

def quizDataForStudentId(dbStudent, dbQuiz, studentId)
    finalResult = Array.new
    result = dbStudent.execute "select scores,dates,name from student where id=#{studentId}"
    if result[0][0] == nil
      return []
    end
    scores = result[0][0].split","
    dates = result[0][1].split","
    name = result[0][2]
    i = 0
    scores.each do |quiz|
      id = quiz.split(" ")[0]
      score = quiz.split(" ")[1]
      name = getQuizName(dbQuiz,id)
      date = dates[i]
      i = i+1
      finalResult.push([id,name,date,score])
    end
  finalResult
end

def quizesForStudent(dbStudent,dbQuiz,studentId)
  query  = dbStudent.execute "select scores,dates from student"
  p query
end

def deleteStudentWithId(dbStudent, studentId)
  query = "delete from student where id=#{studentId}"
  dbStudent.execute query
  return query
end

def rescaleQuizId(dbQuiz,dbStudent,quizId, grade)
  finalresult = Array.new
  query = dbStudent.execute "select scores,id from student"
  result = Array.new
  query.each do |quiz|
    if quiz[0] != nil
      result.push(quiz[0])
    end
  end
  j = 0
  result.each do |quiz|
    quiz = quiz.split(",")
    quiz.each do |i|
      i = i.split(" ")
      #p i
      if i[0].to_s == quizId.to_s
        grd =  i[1].to_i + grade
        finalresult.push([i[0],grd].join(" "))
      end
    end
    dbStudent.execute "update student set scores='#{finalresult.join(",")},' where id=#{query[j][1]}"
    executeStudentUpdate($host,$port,"update student set scores='#{finalresult.join(",")},' where id=#{query[j][1]}")
    j = j+1
  end
end

def rescaleQuizForStudentId(dbStudent, studentId, quizId, grade)
    result = dbStudent.execute "select scores from student where id=#{studentId}"
    if result[0][0] == nil
      return []
    end
    if result == []
      return []
    else
      result =result[0][0].split","
      finalResult = Array.new
      result.each do |quiz|
        quiz = quiz.split(" ")
        if quiz[0].to_s == quizId.to_s
          grd = grade
          finalResult.push("#{quiz[0]} #{grd}")
        else
          finalResult.push("#{quiz[0]} #{quiz[1]}")
        end
      end
      dbStudent.execute "update student set scores='#{finalResult.join(",")}' where id=#{studentId}"
      return "update student set scores='#{finalResult.join(",")},' where id=#{studentId}"
    end
end

def deleteAllQuizzes(dbQuiz, dbStudent, dbQuestion)
    dbQuestion.execute "delete from question"
    dbQuiz.execute "delete from quiz"
    executeQuizzUpdate($host,$port,"delete from quiz")
    executeQuestionUpdate($host, $port, "delete from question")
    result = dbStudent.execute "select id from student"
    ids = Array.new
    result.each do |id|
      ids.push(id[0])
    end
     ids.each do |id|
       query = "update student set scores='', dates='',availablequizes='' where id=#{id}"
       dbStudent.execute query
       executeStudentUpdate($host,$port,query)
       sleep(0.1)
     end
end

def changePass(dbStudent, studentId, pass)
    query = "update student set pass='#{pass}' where id=#{studentId}"
    dbStudent.execute query
    executeStudentUpdate($host, $port, query)
end


def deleteQuizWithId(dbQuiz, dbStudent, dbQuestion, quizId)
    query = "delete from quiz where id=#{quizId}"
    dbQuiz.execute query
    executeQuizzUpdate($host,$port,query)

  questions =  dbQuiz.execute "select questions from quiz where id=#{quizId}"
    p questions
    #questions = questions[0][0].split(" ")
    questions.each do |question|
      q = "delete from question where id=#{question}"
      dbQuestion.execute q
      executeQuestionUpdate($host, $port, q)
    end
    query = "select id, scores,availablequizes,dates from student"
    result = dbStudent.execute query
    result.each do |student|
      id = student[0]
      scores = student[1].split(",")
      availablequizzes= student[2].split" "
      dates = student[3].split","
      i = 0
      newScores = Array.new
      deleteIds = Array.new
      newDates = Array.new
      newAQ = Array.new
      scores.each do |pair|
        localQuizId = (pair.split " ")[0]
        if !(localQuizId.to_i == quizId.to_i)
          newScores.push(pair)
          else
            deleteIds.push(i)
        end
        i = i+1
      end
      deleteIds.each do |idToDelete|
        dates.delete_at(idToDelete)
      end
      availablequizzes.each do |quiz|
        if quiz.to_i != quizId.to_i
          newAQ.push quiz
        end
      end
      if newAQ.nil?
        newAQ = ""
      else
          newAQ = newAQ.join" "
      end
      if newScores.nil?
        newScores = ""
      else
          newScores = newScores.join","
      end
      if dates.nil?
        dates = ""
      else
          dates = dates.join","
      end
      query = "update student set scores='#{newScores}',availablequizes='#{newAQ}',dates='#{dates}' where id=#{id}"
      dbStudent.execute query
      executeStudentUpdate($host, $port, query)
    end
end
