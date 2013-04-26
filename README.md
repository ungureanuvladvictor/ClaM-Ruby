ClaM-Ruby
===========

Project done in Ruby for the course Introduction to Information Systems / Jacobs University Spring 2013.

PURPOSE:
The purpose of this ReadMe file is to help the user get familiar with all the functionalities of Classroom Management Software(ClaM).


STARTUP:
At startup, the user is presented with a login screen, prompting for a username and password. ClaM differentiates between two types of users: students and teachers.

STUDENTS:
If the user logs in as a student, he/she is presented with a list of available quizzes to take and the grades for the most recent quizzes. Then, he/she can take a quiz by simply selecting one from the drop down list and clicking on Take Quiz! Once started, the timer for the quiz starts ticking. When finished, the user clicks on the Submit button to subbmit the quiz. If time runs out, everything that the user has entered so far will be submitted and graded.

PROFESSORS:

At login, the professor is presented with a list of the most recent quizzes(clickable for easy editing). Also, he/she is presented with options to manage students, quizzes and to print all results.

MANAGING_STUDENTS:

The professor can add a student account with his or a random password. When generating a random password, an alert with the password will show, asking the professor to write it down. The professor can also delete all student accounts from the database, he can export all the students data to a .xml file and import students from a .xml file.

MANAGING_QUIZZES:

The professor can do 4 actions:
	Add a quiz
	Clear all quizzes from the database
	Import quizzes from a .xml file
	Export quizzes to a .xml file

Apart from the 4 buttons for the above instructions, a table with all the students grades for each quiz so far appears on the page, allowing the professor easy access to a particular quiz.

ADD_QUIZ:

The professor needs to add a name of the quiz and at least 1 question. There are three different kinds of questions recognized by ClaM:
	Multiple Choice - 1 answer out of several is correct
	Short Answer - A typed answer of 3-4 words is required
	Long Answer - The student is supposed to write a more thorough but still relatively short response to the question.

The "+ Add" button supports all of the three question types. It always adds questions to the bottom of the window and always asks for the following:
	Question statement
	Number of points the question is worth
	The options (if it is a multiple choice question)
	The correct answer to the question

The "- Remove" button will always remove the last added question from the list. This action is not undo-able.

The Cancel button discards all changes to the quiz.

The Submit button stores the quiz into the database and redirects the professor to the Manage Quizzes Page

MANAGE_QUESTIONS:

When a professor selects an already existing quiz, he can choose to edit it with the Manage Questions button. The same interface as the ADD_QUIZ follows.

GRADING:

Grading is done automatically by using an algorithm to determine the similarity between the student's and the correct answer.

RESCALE:

The professor can choose whether he wants to give a rescale for a certain quiz or not. Also, ClaM supports the option of giving a rescale to specific students(used in case the grading algorithm failed to recognize a correct answer or vice versa)