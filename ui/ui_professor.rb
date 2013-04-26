class ProfessorMenu < Shoes

url '/professor_menu', :professor_menu

def professor_menu
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.
	$lastvisited = "/professor_menu"

	stack(:margin => 10) do
		para link("Logout", :click => '/')
			
		fname = getAdminNameByUsername($admin, $name)

		tagline "Welcome back, Prof. #{fname} !"

		l3 = getLatestQuizzes($quiz,3)

		caption "Last added quizzes:"

		link = Array.new(10)
		i=0

		l3.each do |e|
			link[i] = Array.new(2)
			link[i][0] = e[0]
			link[i][1] = e[1]

			para link("\##{link[i][0]}: #{link[i][1]}", :click => "/quiz_stats/#{link[i][0]}")
			i = i+1
		end
		
		para ""

		@b1 = button "Manage students" do
			visit "/manage_students"
		end

		@b2 = button "Manage quizzes" do
			visit "/manage_quizzes"
		end

		@b3 = button "Print all results" do
			alert "Printer is not connected!"
		end

		# Why in the world does this work?
		@b1.style :width => 1.0
		@b2.style :width => 1.0
		@b3.style :width => 1.0
	
	end
end

end 
