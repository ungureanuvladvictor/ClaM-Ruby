 class Login < Shoes

 url '/', :login

 def login
 	$lastvisited = "/"

 	systemInit("192.168.88.212",2000)
 	$quiz = SQLite3::Database.open 'Quiz.db'
	$question = SQLite3::Database.open 'Question.db'
	$student = SQLite3::Database.open 'Student.db'
	$admin = SQLite3::Database.open 'Admin.db'

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

			if (@username.text == "" || @password.text == "")
				alert "Incomplete!"
				return
			end

			debug $admin
			debug @username.text
			debug @password.text

			if (checkLoginAdmin($admin,@username.text,@password.text) == true)
				visit "/professor_menu"
			elsif (checkLoginStudent($student,@username.text,@password.text) == true)
				visit "/student_menu"
			else
				alert "Invalid credentials."
			end
		end
		@b1.style :width => 200, :margin => 10
	end

end

end 
