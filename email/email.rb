
require 'tlsmail'
require 'time'
require "net/smtp"
require "getoptlong"

class Mailer
	attr_accessor :body,:server,:from,:to, :subject, :name, :userId, :password

	def initialize
		random = sprintf("%08X",rand(1000000000))
		time = sprintf("%08X",Time.new.to_i)
		@boundary="----Multipart-Boundry-#{random}-#{time}----"
		@attachments=[]
		@server = @subject = @from = @to = @body = @name = ""
	end

	def attach(fileName)
		raise "#{fileName} not a JPEG" unless(/jpe?g$/.match(fileName))
		data=[
			File.open(fileName,"rb") do |f|
				data=f.read
				f.close
				data
			end
		].pack("m*")
		@attachments.push(
				{
				:name => File.basename(fileName),
				:data => data
				}
			    )
	end

	def sendGMAIL
	    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)  
		Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', @userId,@password, :login) do |smtp|  
			smtpSend(smtp)
		end
	end


	def smtpSend(smtp)
		smtp.ready(@from, @to) do |_smtp|
			_smtp.write("Reply-To: @from\r\n")
			_smtp.write("To: #{@to}\r\n")
			_smtp.write("From: #{@name} <#{@from}>\r\n")
			_smtp.write("Subject: #{@subject}\r\n")
			_smtp.write("MIME-Version: 1.0\r\n")

			_smtp.write("Content-Type: text/html; charset=iso-8859-1\r\n")
			_smtp.write("Content-Transfer-Encoding: 8bit\r\n")
			_smtp.write("\r\n")
			_smtp.write("#{@body}\r\n")
			_smtp.write("\r\n")
		end
	end
end


