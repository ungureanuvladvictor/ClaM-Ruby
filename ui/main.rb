begin
 	require 'lib/utils.rb'
	require 'ui/ui_login'
	require 'ui/ui_student'
	require 'ui/ui_professor'
	require 'ui/ui_quiz'
rescue LoadError
 	p "Packaging failed. Compiling from source..."
  	require '../lib/utils.rb'
	require 'ui_login'
	require 'ui_student'
	require 'ui_professor'
	require 'ui_quiz'
end


Shoes.app(
	:width => 375, 
	:height => 450, 
	:title => "Jacobs CLaM",
	:resizeable => false)

#todo:

#all done ^^