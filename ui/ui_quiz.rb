begin
	require 'ui/ui_table'
rescue LoadError
  	require 'ui_table'
end

class Quiz < Shoes

url '/quiz/(\d+)', :quiz
url '/quiz_stats/(\d+)', :quiz_stats
url '/manage_quizzes', :manage_quizzes
url '/manage_questions/(\d+)', :manage_questions
url '/add_quiz', :add_quiz

# Taking quiz
def quiz(id)

	@quiz_id = id

	stack(:margin => 10) do

		time = Time.now + (15*60);

		quiz_name = getQuizName($quiz,id)
		caption "Quiz ##{id}: #{quiz_name}"
		@timeLabel = caption "Time left: 15 minutes 0 seconds"

		animate(5) do #Timer
			left = ((time - Time.now)/60).to_i
			seconds = ((time - Time.now) - (left*60)).floor
			@timeLabel.replace "Time left: #{left} minutes #{seconds} seconds."

			if (left == 0 && seconds == 0)
				alert "Time's out!"
				submit
			end
		end

		@choose = Array.new

		#Feed with quiz questions
		@qu = getFullQuestionsForQuizWithId($quiz, $question, id)

		i = 0
		@qu.each do |qi|
			i = i+1
			q_name = qi[0]
			q_pts = qi[1]
			q_type = qi[2]
			q_answer = qi[4]

			if (q_type == 0)
				k = 0
				para "Question \##{i}: #{q_name} (#{q_pts})"
				arr = Array.new

				flow do
					while k < q_answer.size
						arr.push(radio)
						para "#{q_answer[k]}\n"
						k = k+1
					end
				end

				@choose.push(arr)

			elsif (q_type == 1)
				para "Question \##{i}: #{q_name} (#{q_pts})"
				@choose.push(edit_line(:width => 0.6, :right => 20))
			elsif (q_type == 2)
				para "Question \##{i}: #{q_name} (#{q_pts})"
				@choose.push(edit_box(:width => 0.6, :height => 100, :right => 20))
			else
				alert "Invalid question type discovered. Please, contact your professor!"
				visit "/student_menu"
			end	

		end

		stack(:width => 10, :margin => 10)
		button ("Submit!"){submit}
	end
end

def submit
	
	answ = Array.new
	sum = 0
	total = 0

	#debug @choose

	i = 0
	@choose.each do |x|

		q_name = @qu[i][0]
		q_pts = @qu[i][1]
		q_type = @qu[i][2]
		q_correct = @qu[i][3]
		q_answer = @qu[i][4]

		total = total + q_pts.to_i

		#debug "#{q_name}, #{q_pts}, #{q_type}, #{q_correct}, #{q_answer}"

		if (x.nil?)
			break
		elsif (x.class == Shoes::EditLine || x.class == Shoes::EditBox)
			answ.push(x.text)
		else
			k = 0
			x.each do |xradio|
				if (xradio.nil?)
					break
				else
					if (xradio.checked?)
						answ.push(q_answer[k])
					end
				end

				k = k+1
			end
		end

		#debug "Got: #{answ[i]}" 
		#debug "Correct: #{q_correct}"
	
		if (calc_cheat(answ[i],q_correct)[0] == true)
			sum = sum + q_pts.to_i
			#debug "Correct answer \##{i}! \nSum: #{sum}"
		end

		i = i+1
	end

	score = ((sum.to_f / total.to_f) * 100).round(2)
	
	s_id = getId($student,$name)
	now = Time.now
	date = "#{now.day}.#{now.month}.#{now.year}"
	cmd = submitQuiz($student, s_id, @quiz_id, score, date)
	executeStudentUpdate($host,$port,cmd)

	visit "/student_menu"
end

# Extended statistics for a quiz
def quiz_stats(id)

	stack(:margin => 10) do

		para link("Back", :click => $lastvisited)

		caption "Displaying info for Quiz \##{id}"

		flow do
			@b21 = button "Delete quiz" do
				#Delete quiz here
				
				deleteQuizWithId($quiz, $student, $question, id)
				visit $lastvisited
			end

			@b22 = button "Print results" do
				alert "Printer is not connected!"
			end

			@b21.style :width => 160
			@b22.style :width => 160, :left => 170
		end

		flow do
			@b23 = button "Manage questions" do	
				visit "/manage_questions/#{id}"
			end

			@b24 = button "Rescale" do
				resc = ask "How much percent would you like to add to everybody? (negative numbers to substract)"

				#Do magic
				if (resc.to_i == 0)
					alert "Please, enter valid non-zero value."
				else
					rescaleQuizId($quiz, $student, id, resc.to_i)
					visit "/quiz_stats/#{id}"
				end

			end

			@b23.style :width => 160
			@b24.style :width => 160, :left => 170
		end

		#Get results
		@function = Proc.new {}

		data = getQuizInfo($student,$quiz,id)

		#Cheating factor
		@table = table(:top => 150, :left => 5, :rows => data.size, :headers => [["#",25],["Student",120],["Date",110],["Score",60]], :items => data,:blk => @function)

	end
end

def manage_questions(qid)

	stack(:margin => 5) do
		para link("Back", :click => $lastvisited)

		inscription "Warning! Altering data for quiz will result in quiz being re-created, and as result, all scores deleted!"

		flow(:margin => 10) do
			para "Name: "
			@name_q = edit_line(:width => 0.6, :right => 20)
			@name_q.text = getQuizName($quiz,qid)
		end

		id = 0

		@input = Array.new
		@out = Array.new

		flow do
			@add = button "+ Add" do

				type = ask "Which type of question?\n[M] Multiple Choice \n[S] Short Answer\n [L] Long Answer"

				if (type == "M" || type == "m")
					id = id + 1
					num = ask "How many options?"

					q_input = Array.new

					@out[id] = stack(:margin => 10) do

						flow do
							para "Question \##{id}: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Points: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						n = num.to_i
						if n<=0
							alert "Please enter a positive number of options!"
							return
						end

						i = 0
						option = Array.new
						while i < n
							flow do
								para "Option \##{i+1}: "
								option.push(edit_line(:width => 0.6, :right => 20))

							end
							i = i+1
						end

						flow do
							para "Correct: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						q_input.push(option)
						@input.push(q_input)
					end


				elsif (type == "S" || type == "s")
					id = id + 1

					q_input = Array.new

					@out[id] = stack(:margin => 10) do
						
						flow do
							para "Question \##{id}: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Points: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Correct: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						q_input.push(nil)
						@input.push(q_input)
					end
				
				elsif (type == "L" || type == "l")
					id = id + 1
					
					q_input = Array.new

					@out[id] = stack(:margin => 10) do
					
					flow do
						para "Question \##{id}: "
						q_input.push(edit_line(:width => 0.6, :right => 20))
					end

					flow do
						para "Points: "
						q_input.push(edit_line(:width => 0.6, :right => 20))
					end

					flow do
						para "Correct: "
						q_input.push(edit_box(:width => 0.6, :height => 100, :right => 20))
					end

					q_input.push(nil)
					@input.push(q_input)

					end



				elsif (type == "" || type.nil?)
					#Do nothing

				else
					alert "Please, specify correct question type!"
				end	

				debug @input

				if id > 0
					@erase.state = nil;
					@submit.state = nil;
				end
			end

			@erase = button "- Remove" do

				@out[id].clear
				@out[id].remove

				@out.pop
				@input.pop

				id = id-1
				if id==0
					@erase.state = "disabled"
					@submit.state = "disabled"
				end
			end

			@erase.style :margin_left => 5
			@erase.state = "disabled"

			@cancel = button "Cancel" do
				visit "/manage_quizzes"
			end

			@cancel.style :margin_left => 5

			@submit = button "Submit!" do
				# CHECK IF FIELDS FILLED				
				ids = Array.new

				deleteQuizWithId($quiz, $student, $question, qid)

				@input.each do |x|

					x_name = x[0].text
					x_points = x[1].text
					x_correct = x[2].text
					x_input = x[3]

					if (x_input != nil)
						x_type = 0
					elsif (x[2].class == Shoes::EditLine)
						x_type = 1
					elsif (x[2].class == Shoes::EditBox)
						x_type = 2
					end

					x_input_s = ""

					if (!x_input.nil?)
						x_input.each do |y|
							x_input_s = x_input_s + y.text + "//"
						end
					end

					x_input_s = x_input_s[0, x_input_s.length-2]

					#debug "Question:\n Name: #{x_name} \n Points: #{x_points} \n Correct = #{x_correct} \n Inputs: #{x_input_s}"

					#write question to db
					ret = addQuestion($question, x_name, x_type, x_input_s, x_correct, x_points)

					#debug ret[1]

					executeQuestionUpdate($host,$port,ret[0])

					#push id to ids
					ids.push(ret[1])

				end

				#create quiz with ids
				id_string = ids.join(" ")
				cmd = addQuiz($quiz, $student, @name_q.text, id_string)
				executeQuizzUpdate($host,$port,cmd)

				

				visit "/manage_quizzes"
			
			end

			@submit.style :margin_left => 5
			@submit.state = "disabled"
		end

		@qu = getFullQuestionsForQuizWithId($quiz, $question, qid)

		@qu.each do |qi|
			
			q_name = qi[0]
			q_pts = qi[1]
			q_type = qi[2]
			q_correct = qi[3]
			q_answer = qi[4]

			debug "Name: #{q_name} \n Points: #{q_pts} \n Type: #{q_type} \n Correct: #{q_correct} \n Answer = #{q_answer}"

			if (q_type == 0)
				id = id + 1

				q_input = Array.new

				@out[id] = stack(:margin => 10) do

					flow do
						para "Question \##{id}: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_name))
					end

					flow do
						para "Points: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_pts))
					end

					i = 0
					option = Array.new
					while i < q_answer.size
						flow do
							para "Option \##{i+1}: "
							option.push(edit_line(:width => 0.6, :right => 20, :text => q_answer[i]))
						end
						i = i+1
					end

					flow do
						para "Correct: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_correct))
					end

					q_input.push(option)
					@input.push(q_input)
				end

			elsif (q_type == 1)
				id = id + 1
				q_input = Array.new

				@out[id] = stack(:margin => 10) do
					
					flow do
						para "Question \##{id}: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_name))
					end

					flow do
						para "Points: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_pts))
					end

					flow do
						para "Correct: "
						q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_correct))
					end

					q_input.push(nil)
					@input.push(q_input)
				end

			elsif (q_type == 2)
				id = id + 1
				q_input = Array.new

				@out[id] = stack(:margin => 10) do
				
				flow do
					para "Question \##{id}: "
					q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_name))
				end

				flow do
					para "Points: "
					q_input.push(edit_line(:width => 0.6, :right => 20, :text => q_pts))
				end

				flow do
					para "Correct: "
					q_input.push(edit_box(:width => 0.6, :height => 100, :right => 20, :text => q_correct))
				end

				q_input.push(nil)
				@input.push(q_input)

				end


			else
				alert "Invalid question type discovered. Please, contact your professor!"
				visit "/student_menu"
			end	

		end

		if id > 0
			@erase.state = nil;
			@submit.state = nil;
		end

	end
end

# Overall quiz statistics
def manage_quizzes

	stack(:margin => 10) do

		para link("Back", :click => "/professor_menu")

		#get array of quizzes for filling the table

		flow do
			@b31 = button "Add quiz" do
				visit "/add_quiz"
			end
			
			@b32 = button "Clear quizzes" do
				if confirm "Are you sure?"
					deleteAllQuizzes($quiz,$student,$question)
					$lastvisited = "/manage_quizzes"
					visit "/manage_quizzes"
				end
			end

			@b31.style :width => 160
			@b32.style :width => 160, :left => 170
		end


		flow do	
			@b33 = button "Export data" do
				fo = ask_save_file
			end
			
			@b34 = button "Import data" do
				fi = ask_open_file
			end
		
			@b33.style :width => 160
			@b34.style :width => 160, :left => 170
		end

		inscription "Click a quiz for detailed info and settings"

		@function = Proc.new do
			|x| 
			$lastvisited = "/manage_quizzes"
			visit "/quiz_stats/#{x[0]}"
		end

		qui = getFullQuizzes($quiz,$student)

		@table = table(:top => 130, :left => 10, :rows => qui.size, :headers => [["#",25],["Name",150],["Taken by",65],["Avg. score",65]], :items => qui,:blk => @function)

	end
end 

#Adding new quiz
def add_quiz

	stack(:margin => 5) do
		para link("Back", :click => "/manage_quizzes")

		flow(:margin => 10) do
			para "Name: "
			@name_q = edit_line(:width => 0.6, :right => 20)
		end

		id = 0

		@input = Array.new
		@out = Array.new

		#stack(:height => 35, :width => 10, :margin => 20){}

		flow do
			@add = button "+ Add" do

				type = ask "Which type of question?\n[M] Multiple Choice \n[S] Short Answer\n [L] Long Answer"

				if (type == "M" || type == "m")
					id = id + 1
					num = ask "How many options?"

					q_input = Array.new

					@out[id] = stack(:margin => 10) do

						flow do
							para "Question \##{id}: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Points: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						n = num.to_i
						if n<=0
							alert "Please enter a positive number of options!"
							return
						end

						i = 0
						option = Array.new
						while i < n
							flow do
								para "Option \##{i+1}: "
								option.push(edit_line(:width => 0.6, :right => 20))

							end
							i = i+1
						end

						flow do
							para "Correct: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						q_input.push(option)
						@input.push(q_input)
					end


				elsif (type == "S" || type == "s")
					id = id + 1

					q_input = Array.new

					@out[id] = stack(:margin => 10) do
						
						flow do
							para "Question \##{id}: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Points: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						flow do
							para "Correct: "
							q_input.push(edit_line(:width => 0.6, :right => 20))
						end

						q_input.push(nil)
						@input.push(q_input)
					end
				
				elsif (type == "L" || type == "l")
					id = id + 1
					
					q_input = Array.new

					@out[id] = stack(:margin => 10) do
					
					flow do
						para "Question \##{id}: "
						q_input.push(edit_line(:width => 0.6, :right => 20))
					end

					flow do
						para "Points: "
						q_input.push(edit_line(:width => 0.6, :right => 20))
					end

					flow do
						para "Correct: "
						q_input.push(edit_box(:width => 0.6, :height => 100, :right => 20))
					end

					q_input.push(nil)
					@input.push(q_input)

					end



				elsif (type == "" || type.nil?)
					#Do nothing

				else
					alert "Please, specify correct question type!"
				end	

				if id > 0
					@erase.state = nil;
					@submit.state = nil;
				end

				debug @input
			end

			@erase = button "- Remove" do

				@out[id].clear
				@out[id].remove

				@out.pop
				@input.pop

				id = id-1
				if id==0
					@erase.state = "disabled"
					@submit.state = "disabled"
				end
			end

			@erase.style :margin_left => 5
			@erase.state = "disabled"

			@cancel = button "Cancel" do
				visit "/manage_quizzes"
			end

			@cancel.style :margin_left => 5

			@submit = button "Submit!" do
				# CHECK FOR NUMBER OF POINTS
				# CHECK IF FIELDS FILLED
				#write to database (somehow)
				
				ids = Array.new

				@input.each do |x|

					x_name = x[0].text
					x_points = x[1].text
					x_correct = x[2].text
					x_input = x[3]

					if (x_input != nil)
						x_type = 0
					elsif (x[2].class == Shoes::EditLine)
						x_type = 1
					elsif (x[2].class == Shoes::EditBox)
						x_type = 2
					end

					x_input_s = ""

					if (!x_input.nil?)
						x_input.each do |y|
							x_input_s = x_input_s + y.text + "//"
						end
					end

					x_input_s = x_input_s[0, x_input_s.length-2]

					#debug "Question:\n Name: #{x_name} \n Points: #{x_points} \n Correct = #{x_correct} \n Inputs: #{x_input_s}"

					#write question to db
					ret = addQuestion($question, x_name, x_type, x_input_s, x_correct, x_points)

					#debug ret[1]

					executeQuestionUpdate($host,$port,ret[0])

					#push id to ids
					ids.push(ret[1])

				end

				#create quiz with ids
				id_string = ids.join(" ")
				cmd = addQuiz($quiz, $student, @name_q.text, id_string)

				executeQuizzUpdate($host,$port,cmd)

				visit "/manage_quizzes"
			
			end

			@submit.style :margin_left => 5
			@submit.state = "disabled"
		end
	end

	#$lastvisited = "/add_quiz"

end

end