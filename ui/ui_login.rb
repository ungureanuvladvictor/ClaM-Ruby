 class Login < Shoes

 url '/', :login

 def login
 	$lastvisited = "/"

	stack(:margin => 10) do
		para ""
		tagline "Welcome to CLaM!"
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
		@b1 = button "Login" do
			
			$name = @username.text
			#check username and password here

			log = ask "name = #{@username.text}, pass = #{@password.text}, rememberme = #{@remember.checked?}. Do checking for validity here.\n(s) to log as student, (p) as professor, (q) to reject the data."
			
			#do the redirecting according to user's rights

			if (log == "p")
				visit "/professor_menu"
			elsif (log == "s")
				visit "/student_menu"
			elsif (log == "q")
				alert "Username/password is wrong. Please, try again or ask your teacher for assistance."
			end
		end
		@b1.style :width => 200, :margin => 10
	end

end

end 
