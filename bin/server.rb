require '../lib/multiclient_tcp_server'
require 'sqlite3'

srv = MulticlientTCPServer.new( 2001, 1, false )

loop do
  if sock = srv.get_socket
    # a message has arrived, it must be read from sock
    message = sock.gets("\r\n").chomp("\r\n")
    # arbitrary examples how to handle incoming messages:
    if !message.nil?
      if File.exist?("../db/#{message}")
      fileToSend = File.open("../db/#{message}",'rb')
      x = fileToSend.read
      sock.puts(x)
      else
        if message[0].chr == 's'
          database = "Student.db"
        elsif message[0].chr == 'q'
          database = "Question.db"
        elsif message[0].chr == 'Q'
          database = "Quiz.db"
        else
          p message[0].chr
        end
        student = SQLite3::Database.open "../db/#{database}"
        student.execute message[2,message.length]
        student.close if student
      end
    else
      sleep 0.01
    end
  end
end