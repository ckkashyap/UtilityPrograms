
require 'tlsmail'
require 'time'
require "net/smtp"
require "getoptlong"

class Mailer
	attr_accessor :body,:server,:from,:to, :subject, :name

	def initialize
		random = sprintf("%08X",rand(1000000000))
		time = sprintf("%08X",Time.new.to_i)
		@boundary="----Multipart-Boundry-#{random}-#{time}----"
		@attachments=[]
		@server = @subject = @from = @to = @body = @name = ""
	end

	def attach(fileName)
#raise "#{fileName} not a JPEG" unless(/jpe?g$/.match(fileName))
		data=[
			File.open(fileName,"rb") do |f|
				data=f.read
				f.close
				data
			end
		].pack("m*")
		@attachments.push(
				{
				:type => "image/jpg",
				:name => File.basename(fileName),
				:data => data
				}
			    )
	end

	def sendGMAIL(user,password)
	    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)  
		Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', user,password, :login) do |smtp|  
			smtpSend(smtp)
		end
	end
	
	def send(server)
		Net::SMTP.disable_tls
		smtp=Net::SMTP.new(server)
		smtp.start
		smtpSend(smtp)
	end


	def smtpSend(smtp)
		smtp.ready(@from, @to) do |_smtp|
			_smtp.write("Reply-To: #{@from}\r\n")
			_smtp.write("To: #{@to}\r\n")
			_smtp.write("From: #{@name} <#{@from}>\r\n")
			_smtp.write("Subject: #{@subject}\r\n")
			_smtp.write("MIME-Version: 1.0\r\n")


			if (@attachments.length > 0)
				_smtp.write("Content-Type: multipart/mixed; boundary=\"#{@boundary}\"\r\n")
				_smtp.write("\r\n")
				_smtp.write("This is a multi-part message\r\n")
				_smtp.write("\r\n")
			end

			if (@attachments.length > 0)
				_smtp.write("--#{@boundary}\r\n")
				_smtp.write("Content-Type: text/html; charset=\"iso-8859-1\"\r\n")
				_smtp.write("Content-Transfer-Encoding: 8bit\r\n")
			else
				_smtp.write("Content-Type: text/html; charset=iso-8859-1\r\n")
				_smtp.write("Content-Transfer-Encoding: 8bit\r\n")
			end

			_smtp.write("\r\n")
			_smtp.write("#{@body}\r\n")
			_smtp.write("\r\n")



			if (@attachments.length > 0)
				@attachments.each do |part|
					_smtp.write("--#{@boundary}\r\n")
					_smtp.write("Content-Id: <#{part[:name]}>\r\n") # In the HTML, use src="cid:theid"
					_smtp.write("Content-Type: #{part[:type]}; name=\"#{part[:name]}\"\r\n")
					_smtp.write("Content-Transfer-Encoding: base64\r\n")
					_smtp.write("Content-Disposition: inline; filename=\"#{part[:name]}\";\r\n")
					_smtp.write("\r\n")
					_smtp.write("#{part[:data]}")  
					_smtp.write("\r\n")

				end
			end

			_smtp.write("--#{@boundary}--\r\n") if (@attachments.length > 0)
		end 
	end # smtpSend
end
