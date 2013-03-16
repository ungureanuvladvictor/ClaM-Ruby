class ProfessorMenu < Shoes

url '/professor_menu', :professor_menu

def professor_menu
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.
	$lastvisited = "/professor_menu"

	stack(:margin => 10) do
		para link("Logout", :click => '/')
			
		tagline "Welcome back, Prof. #{$name} !"

		caption "Last added quiz:"
		para link("N27. Italian Art.", :click => '/quiz_stats/27')

		caption "Latest submission:"
		para link("N5. Sharks (by G.Bush)", :click => "/quiz_stats/5")

		para ""

		@b1 = button "Manage students" do
			visit "/manage_students"
		end

		@b2 = button "Manage quizzes" do
			visit "/manage_quizzes"
		end

		@b3 = button "Print all results" do

		end

		# Why in the world does this work?
		@b1.style :width => 1.0
		@b2.style :width => 1.0
		@b3.style :width => 1.0
	
	end
end

end 
