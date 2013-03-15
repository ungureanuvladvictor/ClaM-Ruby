class ProfessorMenu < Shoes

url '/professor_menu/(\w+)', :professor_menu

def professor_menu(name)
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.

	stack do
		para link("Logout", :click => '/')
		flow do
			tagline "Welcome back, "
			subtitle name + "!"
		end

	end
	
end

end