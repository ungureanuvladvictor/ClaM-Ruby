require 'ui_table'

class Quiz < Shoes

url '/quiz/(\d+)', :quiz
url '/quiz_stats/(\d+)', :quiz_stats
url '/manage_quizzes', :manage_quizzes
url '/add_quiz', :add_quiz

# Taking quiz
def quiz(id)

	stack(:margin => 10) do

		time = Time.now + (30*60);

		caption "Quiz  ##{id}"
		@timeLabel = caption "Time left: 30 minutes 0 seconds"

		animate(5) do #Timer
			left = ((time - Time.now)/60).to_i
			seconds = ((time - Time.now) - (left*60)).floor
			@timeLabel.replace "Time left: #{left} minutes #{seconds} seconds."

			if (left == 0 && seconds == 0)
				alert "Time's out!"
				submit
			end
		end

		@content = stack :width => 340,:height  => 320, :scroll=>true do
			#Feed with quiz questions
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
			caption "DERP"
		end

		# Add spacing here somehow
		button ("Submit"){submit}

	end
end

def submit
	alert "Quiz submitted!"
	visit "/student_menu"
end

# Extended statistics for a quiz
def quiz_stats(id)

	stack(:margin => 10) do

		para link("Back", :click => $lastvisited)

		caption "Displaying info for Quiz ##{id}"

		flow do
			@b21 = button "Delete quiz" do

			end

			@b22 = button "Print results" do

			end

			@b21.style :width => 160
			@b22.style :width => 160, :left => 170
		end

		flow do
			@b23 = button "Manage questions" do

			end

			@b24 = button "Rescale" do

			end

			@b23.style :width => 160
			@b24.style :width => 160, :left => 170
		end

		#Get results
		@function = Proc.new {}
		@table = table(:top => 150, :left => 5, :rows => 8, :headers => [["#",25],["Student",120],["Score",60],["Errors",60],["Ch.F",50]], :items => [[1,"Name1","5","80%",""]],:blk => @function)

	end
end

# Overall quiz statistics
def manage_quizzes
	$lastvisited = "/manage_quizzes"

	stack(:margin => 10) do

		para link("Back", :click => "/professor_menu")

		#get array of quizzes for filling the table

		flow do
			@b31 = button "Add quiz" do

			end
			
			@b32 = button "Clear quizzes" do

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

		inscription "Click a quiz for detailed info and settings"

		@function = Proc.new do
			|x| 
			visit "/quiz_stats/#{x[0]}"
		end

		@table = table(:top => 130, :left => 10, :rows => 8, :headers => [["#",25],["Name",150],["Taken by",65],["Avg. score",65]], :items => [[1,"Name1","5",80]],:blk => @function)

	end
end 

#Adding new quiz
def add_quiz

end

end