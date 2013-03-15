Shoes.app(
	:width => 300, 
	:height => 500, 
	:title => "Jacobs CLaM") do
	
	stack do

		tagline "Welcome to CLAM!"
		caption "Please, authorize."
		para ""
		flow(:margin => 10) do
			para "Login: "
			@username = edit_line(:width => 0.6, :right => 20)
		end
		flow(:margin => 10) do
			para "Password: "
			@password = edit_line(:width => 0.6, :right => 20, :secret => true)
		end
		flow(:margin => 10) do
			@remember = check
			para "Remember me"
		end
		button "Login" do
			log = ask "name = #{@username.text}, pass = #{@password.text}, rememberme = #{@remember.checked?}. Do checking for validity here.\n(s) to log as student, (p) as professor, (q) to reject the data."
			
			if (log == "p")
				alert "Professor!"
			elsif (log == "s")
				alert "Student!"
			elsif (log == "q")
				alert "Wrong data!"
			end

		end

	end

end