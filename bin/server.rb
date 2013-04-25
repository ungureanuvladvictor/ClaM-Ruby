require '../lib/multiclient_tcp_server'
require 'sqlite3'

srv = MulticlientTCPServer.new( 2000, 1, false )

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
        student = SQLite3::Database.open '../db/Student.db'
        student.execute message
        student.close if student
      end
    else
      sleep 0.01
    end
  end
end