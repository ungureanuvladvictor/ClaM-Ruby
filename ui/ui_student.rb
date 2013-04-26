begin
	require 'ui/ui_table'
rescue LoadError
  	require 'ui_table'
end

class StudentMenu < Shoes

url '/student_menu', :student_menu
url '/student_stats/(\d+)', :student_stats
url '/manage_students', :manage_students
url '/add_student', :add_student

def student_menu
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.
	$lastvisited = "/student_menu"

	stack(:margin => 10) do
		para link("Logout", :click => '/')

		fname = getStudentNameByUsername($student, $name)

		tagline "Welcome back, #{fname} !"
		caption "Available quizzes:"

		id = getId($student,$name)
		quiz = getAvailableQuizesForId($student,$quiz,id)

		@choose = list_box :items => quiz

		@b1 = button "Take a quiz!" do
			if (@choose.text == nil)
				alert "Please, pick a quiz!"
			else
				id = getQuizIdForName($quiz,@choose.text)
				visit "/quiz/#{id}"
			end
		end
		
		@choose.style :width => 1.0
		@b1.style :displace_left => 145, :width => 200

		#para ""
		caption "Last results:"

		@function = Proc.new {}

		res = getQuizzesTaken($student, $quiz, id)

		@table = table(:top => 240, :left => 10, :rows => res.size, :headers => [["#",25], ["Quiz",135], ["Date",100], ["Grade",60]], :items => res, :blk => @function)

	end
end

# Extended statistics for a quiz
def student_stats(id)

	stack(:margin => 10) do

		para link("Back", :click => $lastvisited)

		fname = getStudentNameById($student, id)

		caption "Displaying info for #{fname}"

		flow do
			@b21 = button "Reset password" do
				newpass = ask "Please, type the new password or enter <rand> for randomly generated one."

				if (newpass == "<rand>")
					b = true
					value = "" 
					8.times{value << ((rand(2)==1?65:97) + rand(25)).chr}
					newpass = value
					alert "Please write down this generated password: #{newpass}"
				end

				# Save pwd to db

				changePass($student,id,newpass)

			end

			@b22 = button "Delete student" do
				
				cmd = deleteStudentWithId($student, id)
				executeStudentUpdate($host,$port,cmd)

				visit $lastvisited
			end

			@b21.style :width => 160
			@b22.style :width => 160, :left => 170
		end

		flow do
			@b23 = button "Print results" do
				alert "Printer is not connected!"
			end

			@b24 = button "Rescale" do

				dialog :height => 200, :width => 300 do

					stack(:margin => 10) do	
						caption "Quiz to rescale:"

						raw = getQuizzesTaken($student, $quiz, id)
						namz = Array.new
						idz = Array.new

						raw.each do |el|
							namz.push(el[1])
							idz.push(el[0])
						end

						@choise = list_box :items =>  namz

						flow(:top => 75) do
							caption "New grade:   "
							@in = edit_line(:width => 0.5)
						end

						para ""

						flow do
							@b1 = button "Rescale" do

								if (@choise.text == nil || @choise.text == "")
									alert "Please, select a valid quiz!"
									close
								else
									q_id = idz[namz.index(@choise.text)]

									cmd = rescaleQuizForStudentId($student, id, q_id, @in.text.to_f.round(2))

									if (cmd != [])
										executeStudentUpdate($host,$port,cmd)
									end

									owner.visit "/student_stats/#{id}"
									close
								end

							end

							@b2 = button "Cancel" do
								close
							end
						end
						
						@choise.style :width => 1.0
						@b1.style :width => 135
						@b2.style :width => 135, :left => 145  
					end	
				end
			end

			@b23.style :width => 160
			@b24.style :width => 160, :left => 170
		end

		#Get results
		@function = Proc.new {}

		data = quizDataForStudentId($student,$quiz,id)

		@table = table(:top => 150, :left => 5, :rows => data.size, :headers => [["#",25],["Quiz",120],["Date",110],["Score",60]], :items => data,:blk => @function)

	end
end

def manage_students

	$lastvisited = "/professor_menu"

	stack(:margin => 10) do

		para link("Back", :click => "/professor_menu")

		#get array of quizzes for filling the table

		flow do
			@b31 = button "Add student" do
				visit "/add_student"
			end
			
			@b32 = button "Delete all" do
				if confirm("Are you sure?")
					deleteAllStudents($student)
					executeStudentUpdate($host,$port,"delete from student")
					visit "/manage_students"
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

		inscription "Click a student for detailed info and settings"

		@function = Proc.new do
			|x| 
			$lastvisited = "/manage_students"
			visit "/student_stats/#{x[0]}"
		end

		st = getFullStudents($student)

		@table = table(:top => 130, :left => 10, :rows => st.size, :headers => [["#",25],["Name",150],["\#Taken",65],["Avg. score",65]], :items => st,:blk => @function)

	end
end

def add_student

	#$lastvisited = "/add_student"
	b = false

	stack(:margin => 10) do

		para link("Back", :click => "/manage_students")

		flow(:margin_top => 100) do
			para "Name:"
			@name = edit_line(:width => 0.6, :right => 20)
		end

		flow(:margin_top => 30) do
			para "Username:"
			@username = edit_line(:width => 0.6, :right => 20)
		end

		flow do
			para "Password:"
			@pwd = edit_line(:width => 0.6, :right => 20, :secret => true)
		end

		flow do
			@bb = button "Random" do
				b = true
				value = "" 
				8.times{value << ((rand(2)==1?65:97) + rand(25)).chr}
				@pwd.text = value
			end
			@bb.style :width => 80, :right => 20, :height => 25, :bottom => 260
		end

		flow do
			@cancel = button "Cancel" do
				visit "/manage_students"
			end

			@cancel.style :width => 120, :height => 40, :bottom => 120

			@submit = button "Submit" do

				if (b == true)
					alert "Please write down this generated password: #{@pwd.text}"
				end
				
				#request to database
				cmd = addStudent($student,$quiz,@name.text,@username.text,@pwd.text)
				executeStudentUpdate($host,$port,cmd)

				visit "/manage_students"
			end

			@submit.style :width => 120, :height => 40, :right => 20, :bottom =>120
		end

	end


end

end 