require '../lib/utils'

#requestFile('localhost', 2000, 'Quiz.db')
=begin
sock = begin
  Timeout::timeout( 1 ) { TCPSocket.open( '127.0.0.1', 2000 ) }
rescue StandardError, RuntimeError => ex
  raise "cannot connect to server: #{ex}"
end

sock.write( "dude\r\n" )
response = begin
  Timeout::timeout(1) {
    sock.recv(10000).chomp("\n")
  }
rescue TimeoutError,StandardError, RuntimeError => ex
  raise "no response from server: #{ex}"
end

p response
#fileToWrite = File.open("#{file}", 'wb')
#fileToWrite.print(response)
#fileToWrite.close
sock.close
=end

#systemInit('localhost',2000)