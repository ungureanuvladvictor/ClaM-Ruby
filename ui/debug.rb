require 'ui_table'

Shoes.app(
	:width => 300, 
	:height => 500, 
	:title => "Jacobs CLaM") do

	stack(:margin => 10) do

		para link("Back", :click => $lastvisited)

		#get array of quizzes for filling the table

		flow do
			@b1 = button "Add quiz" do

			end
			
			@b2 = button "Clear quizzes" do

			end

			@b1.style :width => 120
			@b2.style :width => 120, :left => 130
		end


		flow do	
			@b3 = button "Export data" do

			end
			
			@b4 = button "Import data" do

			end
		
			@b3.style :width => 120
			@b4.style :width => 120, :left => 130
		end

		@function = Proc.new do
			|x| 
			$lastvisited = "/manage_quizzes"
			visit "/quiz_stats/#{x[0]}"
		end

		@table = table(:top => 120, :left => 10, :rows => 10, :headers => [["#",25],["Name",120],["Taken by",50],["Avg. score",50]], :items => [[1,"Name1","5","80%"]],:blk => @function)

	end
end 
