class ProfessorMenu < Shoes

url '/professor_menu/(\w+)', :professor_menu

def professor_menu(name)
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.

	stack(:margin => 10) do
		para link("Logout", :click => '/')
			
		tagline "Welcome back, Prof. #{name} !"

		caption "Last added quiz:"
		para link("N27. Italian Art.", :click => '/quiz_stats/27')

		caption "Latest submission:"
		para link("N5. Sharks (by G.Bush)", :click => "/quiz_stats/5")

		para ""
		@b1 = button "Manage students"
		@b2 = button "Manage quizzes"
		@b3 = button "Manage grades"

		# Why in the world does this work?
		@b1.style :width => (self.width-10)
		@b2.style :width => (self.width-30)
		@b3.style :width => (self.width-30)
	
	end
end

end 
