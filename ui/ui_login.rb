require 'digest/sha1'

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
			#@username.text = "test"
		end
		flow(:margin => 10) do
			para "Password: "
			@password = edit_line(:width => 0.6, :right => 20, :secret => true)
			#@password.text = "test"
		end
		flow(:margin => 10) do
			@remember = check
			para "Remember me"
		end

		flow(:margin => 10) do
			para "Host/port: "
			@host = edit_line(:width => 0.52, :margin_left => 40, :margin_right => 10)
			@host.text = "localhost"
			@port = edit_line(:width => 0.2, :right => 20)
			@port.text = "2001"
		end

		@b1 = button "Login" do
			
			$name = @username.text
			$host = @host.text
			$port = @port.text.to_i

			if (!systemInit($host,$port))
				alert "Can not connect to server!"
				break
			end

 			$quiz = SQLite3::Database.open 'Quiz.db'
			$question = SQLite3::Database.open 'Question.db'
			$student = SQLite3::Database.open 'Student.db'
			$admin = SQLite3::Database.open 'Admin.db'

			#check username and password here
			if (@username.text == "" || @password.text == "")
				alert "Incomplete!"
				return
			end

			sha_pass = Digest::SHA1.hexdigest @password.text
			p sha_pass

			if (checkLoginAdmin($admin,@username.text,sha_pass) == true)
				visit "/professor_menu"
			elsif (checkLoginStudent($student,@username.text,sha_pass) == true)
				visit "/student_menu"
			else
				alert "Invalid credentials."
			end
		end
		@b1.style :width => 200, :margin => 10
	end

end

end 
