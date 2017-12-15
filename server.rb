require "socket"
class Server
  def initialize( port, ip )
    @server = TCPServer.open( ip, port )
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    run
  end

  def run
    loop {
      Thread.start(@server.accept) do | client |
        nick_name = client.gets.chomp.to_sym
        @connections[:clients].each do |other_name, other_client|
          if nick_name == other_name || client == other_client
            client.puts "This username already exist"
            Thread.kill self
          end
        end
        puts "#{nick_name} #{client}"
        @connections[:clients][nick_name] = client
        client.puts "Connection established, Thank you for joining! Happy chatting"
        listen_user_messages( nick_name, client )
      end
    }.join
  end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      @connections[:clients].each do |other_name, other_client|
        unless other_name == username
          other_client.puts "#{username.to_s}: #{msg}"
        end
      end
    }
  end
end
=begin
class Server
	def initialize(port, ip)
		@server = TCPServer.open(ip, port)
		@connections = Hash.new
		@rooms = Hash.new
		@clients = Hash.new
		@connections[:server] = @server
		@connections[:rooms] = @rooms
		@connections[:cients] = @clients
		run
	end

	def run
		loop {
			#for each user connected and accepted by server, create new thread object
			#and pass connected client as instance to block

			Thread.start(@server.accept) do |client|
				nick_name = client.gets.chomp.to_sym
				@connections[:clients].each do |other_name, other_client|
					if nick_name == other_name || client == other_client
						client.puts "This username already exists"
						Thread.kill self
					end
				end
				puts "#{nick_name} #{client}"
				@connections[:clients][nick_name] = client
				client.puts "Connection established!"
				listen_user_messages(nick_name, client)
			end
		}.join
	end

	def listen_user_messages(username, client)
		loop {
			#get client message
			msg = client.gets.chomp
			#send boradcast message to all users but not self
			@connections[:clients].each do |other_name, other_client|
				unless other_name == username
					other_client.puts "#{username.to_s}: #{msg}"
				end
			end
		}
	end
end
=end
Server.new( 3000, "localhost")

=begin
what the hashes will look like
# hash Connections preview
connections: {
  clients: { client_name: {attributes}, ... },
  rooms: { room_name: [clients_names], ... }
}
=end
