require 'ui_table'

class StudentMenu < Shoes

url '/student_menu', :student_menu
url '/student_stats/(\w+)', :student_stats
url '/manage_students', :manage_students
url '/add_student', :add_student

def student_menu
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.
	$lastvisited = "/student_menu"

	stack(:margin => 10) do
		para link("Logout", :click => '/')
		tagline "Welcome back, #{$name} !"
		caption "Available quizzes:"
		@choose = list_box :items => ["1","2","3"]

		@b1 = button "Take a quiz!" do
			if (@choose.text == nil)
				alert "Please, pick a quiz!"
			else
				id = @choose.text
				alert "/quiz/#{id}"
				visit "/quiz/#{id}"
			end
		end
		
		@choose.style :width => 1.0
		@b1.style :displace_left => 145, :width => 200

		para ""
		caption "Last results:"

		@function = Proc.new {}

		@table = table(:top => 240, :left => 10, :rows => 5, :headers => [["#",25], ["Quiz",135], ["Date",100], ["Grade",60]], :items => [[1,"Quizname1","11/11/11","100"],[2,"Quizname2","11/11/11","100"],[3,"Quizname3","11/11/11","100"],[4,"Quizname4","11/11/11","100"],[5,"Quizname5","11/11/11","100"]], :blk => @function)

	end
end

# Extended statistics for a quiz
def student_stats(name)

	stack(:margin => 10) do

		para link("Back", :click => $lastvisited)

		caption "Displaying info for #{name}"

		flow do
			@b21 = button "Reset password" do
				alert "New password: -----"
			end

			@b22 = button "Delete student" do

			end

			@b21.style :width => 160
			@b22.style :width => 160, :left => 170
		end

		flow do
			@b23 = button "Print results" do

			end

			@b24 = button "Rescale" do
				dialog :height => 200, :width => 300 do
					stack(:margin => 10) do	
						caption "Quiz to rescale:"
						@choose = list_box :items => ["Quiz1","Quiz2","Quiz3"]

						flow(:top => 75) do
							caption "New grade:   "
							@in = edit_line(:width => 0.5)
						end

						para ""

						flow do
							@b1 = button "Rescale" do

							end

							@b2 = button "Cancel" do
								close
							end
						end
						
						@choose.style :width => 1.0
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
		@table = table(:top => 150, :left => 5, :rows => 8, :headers => [["#",25],["Quiz",120],["Score",60],["Errors",60],["Ch.F",50]], :items => [[1,"Name1","5","80%",""]],:blk => @function)

	end
end

def manage_students
	$lastvisited = "/manage_students"

	stack(:margin => 10) do

		para link("Back", :click => "/professor_menu")

		#get array of quizzes for filling the table

		flow do
			@b31 = button "Add student" do

			end
			
			@b32 = button "Delete all" do

			end

			@b31.style :width => 160
			@b32.style :width => 160, :left => 170
		end


		flow do	
			@b33 = button "Export data" do

			end
			
			@b34 = button "Import data" do

			end
		
			@b33.style :width => 160
			@b34.style :width => 160, :left => 170
		end

		inscription "Click a student for detailed info and settings"

		@function = Proc.new do
			|x| 
			visit "/student_stats/#{x[1]}"
		end

		@table = table(:top => 130, :left => 10, :rows => 8, :headers => [["#",25],["Name",150],["Taken by",65],["Avg. score",65]], :items => [[1,"Name1","5","80%"]],:blk => @function)

	end
end

def add_student


end

end 