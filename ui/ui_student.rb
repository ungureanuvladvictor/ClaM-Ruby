require 'ui_table'

class StudentMenu < Shoes

url '/student_menu/(\w+)', :student_menu

def student_menu(name)
	#Before logging out, delete all the cache and stuff
	#Additional URL /cleanup can be created.

	stack(:margin => 10) do
		para link("Logout", :click => '/')
		tagline "Welcome back, #{name} !"
		caption "Available quizzes:"
		@choose = list_box :items => ["Quiz1","Quiz2","Quiz3"]
		@b1 = button "Take a quiz!"
		
		@choose.style :width => self.width-10
		@b1.style :displace_left => 120, :width => 200

		para ""
		caption "Last results:"

		@z=Proc.new {|x| alert x}
		@t1 = table(:top => 240, :left => 10, :rows => 5, :headers => [["#",25], ["Quiz",120], ["Date",100], ["Grade",50]], :items => [[1,"Quizname1","11/11/11","100"],[2,"Quizname2","11/11/11","100"],[3,"Quizname3","11/11/11","100"],[4,"Quizname4","11/11/11","100"],[5,"Quizname5","11/11/11","100"]], :blk => @z)

	end
end

end 
