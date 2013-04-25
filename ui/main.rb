require 'ui_login'
require 'ui_student'
require 'ui_professor'
require 'ui_quiz'

Shoes.app(
	:width => 375, 
	:height => 450, 
	:title => "Jacobs CLaM",
	:resizeable => false)

#todo:

#addquiz
#addstudent
#quizstack(:height => 10, :width => 10, :margin => 20){}@scrollbox.scroll_top(@scroll.scroll_max);