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


Colors=["red","green","blue","magenta","Crimson","DarkGreen","DarkCyan","DarkBlue","DarkGreen","DarkMagenta","DarkOliveGreen","Darkorange","DarkOrchid","DeepPink","Chartreuse","GreenYellow","Maroon","OrangeRed","SaddleBrown" ]
def getdecoratedtext(str)
    out=""
    str=`echo "#{str}" | perl garble.pl`
    str.split(//).each do |i|
        color=rand(Colors.length)
        out="#{out}<font color=\"#{Colors[color]}\">#{str[i]}</font>"
    end
    return out
end
def getcolortext
    out=""
    Colors.each do |c|
        out="#{out}<font color=\"#{c}\">#{c}</font><BR>\n"
    end
    return out
end
def getMessage (to)
msgstr = <<"END_OF_MESSAGE"
Hi #{to},
I wish you and your family a very very Happy Diwali !!!
Regards,
Kashyap
END_OF_MESSAGE
msgstr=getdecoratedtext(msgstr)
cc=getcolortext
html_start=<<END_OF_MESSAGE
<HTML>
<body bgcolor="white"> <font size="7"><pre>
<img src="cid:hello.jpg" align="baseline" border="0">
END_OF_MESSAGE
html_end=<<END_OF_MESSAGE
</pre>
</font>
</body>
</HTML>
END_OF_MESSAGE
"#{html_start}#{msgstr}#{html_end}"
end

nameList=[
############### X RFT ###################
["suma.byrappa@gmail.com","Suma"],
["prathima.nagesh@gmail.com","Prathima"],
["yrk.mahesh@gmail.com","Yrk"],
["srinivas.alladi@in.ibm.com","Srini"],
["rajmith@gmail.com","Mithun"],
["kumar.rangarajan@gmail.com","Kumar"],
["slaturkar@yahoo.com","Sanjay"],

############### IBM SVT ###################
["manjucharan@in.ibm.com","Charan"],
["shrutiujjwal@gmail.com","Shruti"],
["pranam.sreedhar@in.ibm.com","Pranam"],
["swathi.rao@in.ibm.com","Swathi"],
["prathiba.r@in.ibm.com","Prathibha"],
["komal.mirchandani@in.ibm.com","Komal"],
["siddharth.kaushal@gmail.com","Sid"],
["rajgoyal@in.ibm.com","Rajneesh"],
["ananda.bairy@in.ibm.com","Ananda"],
["tirumalai@in.ibm.com","Srini"],
["ckaushik@in.ibm.com","Shekhar"],
["chethna_shenoy@in.ibm.com","Chethana"],
["hamuleva@in.ibm.com","Harish"],


############### IBM DOC ###################
["swathi.jain@in.ibm.com","Swathi"],
["indukalpa.lahon@in.ibm.com","Indu"],
["veena.kumari@in.ibm.com","Veena"],
["creslobo@in.ibm.com","Cresilla"],

############### ASQ OTHERS ###################
["nsrivast@in.ibm.com","Navneet"],
["skuravin@in.ibm.com","Sunil"],
["pradeepb@in.ibm.com","Pradeep"],
["mzacharia@in.ibm.com","Manoj"],
["pchandor@in.ibm.com","Pramod"],
["haananth@in.ibm.com","Hari"],
["kparvath@in.ibm.com","Kamala"],
["raksha.vasisht@in.ibm.com","Raksha"],
["vaibhav.srivastava@in.ibm.com","Vaibhav"],
["praveen.sinha@in.ibm.com","Praveen"],
["sharames@in.ibm.com","Sharmila"],
["ashishmathur@in.ibm.com","Ashish"],
["kiran.m.n@in.ibm.com","Kiran"],
["srikanth_sankaran@in.ibm.com","Srikanth"],


############### RFT ###################
["saammana@in.ibm.com","Sasi"],
["satyam.kandula@in.ibm.com","Satyam"],
["sharma.nitin@in.ibm.com","Nitin"],
["balaji.srinivasan@in.ibm.com","Balaji"],
["srinrven@in.ibm.com","Srinivas"],
["mhosurma@in.ibm.com","Manjula"],
["madhu.tadiparthi@in.ibm.com","Madhu"],
["shinoj.zacharias@in.ibm.com","Shinoj"],
["rawasthy@in.ibm.com","Richa"],
["snehpaul@in.ibm.com","Paul"],
["lshanmug@in.ibm.com","Lakshmi"],
["madankasi@in.ibm.com","Madan"],
["pshanker@in.ibm.com","Shanker"],
["jityadav@in.ibm.com","Jitendra"],
["rasantha@in.ibm.com","Ranjani"],
["nsachan11@in.ibm.com","Namitha"],
["swethasivaram@in.ibm.com","Swetha"],
["sai_krishna@in.ibm.com","Sai"],
["merclobo@in.ibm.com","Mercia"],
["snarasip@in.ibm.com","Sreehari"],
["prakash.chauhan@in.ibm.com","Prakash"],


######################### RATIONAL OTHERS #####################
["kurianjo@in.ibm.com","Kurian"],
["tvohra@gmail.com","Tanuj", 
["parewari@in.ibm.com","Pawan"],
["sujsubra@in.ibm.com","Sujatha"],
["naachaia@in.ibm.com","Naina"],
["gopi.jana@in.ibm.com","Gopi"],
["manjunath.narasimhaiah@in.ibm.com","Manjunath"],
["nagaraja.v@in.ibm.com","Nagaraj"],
["mdharmarajan@in.ibm.com","Dharma"],
["kdakshin@in.ibm.com","Karthi"],
["pratshah@in.ibm.com","Pratik"],
["bhumikabalani@in.ibm.com","Bhumika"],
["msachidanand@in.ibm.com","Sachi"],
["r_balasub@in.ibm.com","Bala"],
["ujjbalan@in.ibm.com","Ujjwala"],
["rthakkar@in.ibm.com","Rajesh"],
["ashok.kurup@in.ibm.com","Ashok"],
["sudiptoghosh@in.ibm.com","Sudipto"],
["schirame@in.ibm.com","Sheeba"],
["eliztrek@in.ibm.com","Liz"],
["mehul.mehta@in.ibm.com","Mehul"],
["sreerupa.sen@in.ibm.com","Sreerupa"],
["sandeep.kohli@in.ibm.com","Sandeep"],
["amrmalli@in.ibm.com","Amrapalli"],
["seuppala@in.ibm.com","Seshaiah"],
["vizsriva@in.ibm.com","Vizeet"],


######################### FRIENDS #####################"]","
["arjunsw@yahoo.com","Arjun"],
["sitaram.chamarty@tcs.com","Sita"],
["niraj17@gmail.com","Niraj"],
["gurudutt.kumar@in.ibm.com","Gurudutt"],
["royashok@yahoo.com","Roy"],
["amju_200@yahoo.co.uk","Amjad"],
["sankalpab@yahoo.com","Sanki"],
["drak_bits@yahoo.com","Rajesh"],
["nkolar@gmail.com","Nikhil"],
["bhagvank@gmail.com","Bhagvan"],
["shantarama@yahoo.com","Shanta"],
["rahul@alumni.fit.edu","Rahul"],


["anilkumar@sobha.co.in","Anil"],
["girishv@us.ibm.com","Girish"],
["rlatha@in.ibm.com","Latha"],
["ahanjura@gmail.com","Anubhav"],

######################### FRIENDS SUN #####################"
["ranajit.ghosh@sun.com","Ranajit"],
["vinutha.nagaraju@sun.com","Vinutha"],
["suresh.warrier@sun.com","Suresh"],
["manoj.malhotra@sun.com","Manoj"],
["raju.macharla@sun.com","Raju"],
["poonam.bajaj@sun.com","Poonam"],
["preeti.prayag@sun.com","Preeti"],
["priya.ravi@sun.com","Priya"],
["pramod.batni@sun.com","Pramod"],


################################### PPM ####################"

["deepak.azad@in.ibm.com","Deepak"],
["aakash.agarwal@in.ibm.com","Akash"],
["francis.sujai@in.ibm.com","Francis"],
["suryakant@in.ibm.com","Surya"],
["jyoti.jagga@in.ibm.com","Jyothi"],
["aradhya1982@in.ibm.com","Aradhya"],
["anilkulkarni@in.ibm.com","Anil"],
["sharoonsk@in.ibm.com","Sharoon"],
["premananda.mohapatra@in.ibm.com","Prem"],
["suresh.nelamangala@in.ibm.com","Suresh"],
["priti.patil@in.ibm.com","Priti"],
["aprassan@in.ibm.com","Andal"],
["anil.tenneti@in.ibm.com","Anil"],
["ajay_yadav@in.ibm.com","Ajay"],
["sargarpe@in.ibm.com","Saritha"],
["vipin.kumar@in.ibm.com","Vipin"],
["rajdathan@in.ibm.com","Raj"],
["damascar@in.ibm.com","Daniel"],
["roomenon@in.ibm.com","Roopa"],
["gururprasad@in.ibm.com","Guru"],
["dyarrang@in.ibm.com","Deepa"],
["dishriva@in.ibm.com","Divya"],
["pauljose@in.ibm.com","Paul"],
["rajesh.kanna@in.ibm.com","Rajesh"],
["hrishikesh.kumar@in.ibm.com","Hrishi"],
["sachinnayak@in.ibm.com","Sachin"],
["vikas.bsetty@in.ibm.com","Vikas"],
["ansharm6@in.ibm.com","Ankur"],
["sandeep.s@in.ibm.com","Sandeep"],
["tepapann@in.ibm.com","Tejaswini"],



######################### FRIENDS INSILICA #####################
["vinod_k_gopinath@yahoo.com","Vinod"],
["prashanthkumara@gmail.com","Apk"],
["vijayasagar@gmail.com","Sagar"],
["sanchetinirmal@gmail.com","Nirmal"],
["dk_jindal@yahoo.com","Deepak"],
["karthik_s_76@yahoo.com","Karthick"],


################ COTTONS

["zak.ahmed@gmail.com","Zakir"],
["drjathinrai@gmail.com","Jathin"],
["kmanikantan@hotmail.com","Kapila"],
["nithan@gmail.com","Nithan"],

["bsuparna@in.ibm.com","Suparna"],

["ckvijayaraghavan@gmail.com","Achanjee!!!"],
["tkchitra@gmail.com","Mom!!!"],
["ckrishi@microsoft.com","Rishi"],

################ MICROSOFT
["arvindp@exchange.microsoft.com","Arvind"],
["Rahul.Bhagat@fidelity.co.in","Rahul"],


######## BITS
["psubramanian@gmail.com","Prasanth"],
["jisha.abubaker@gmail.com","Jisha"],
["ramk10@yahoo.com","Punra"],
["prasanna.krishnan.wg07@wharton.upenn.edu","Prasanna"],
["aparajitp@yahoo.com","Appu"],
["vikasmkasturi@yahoo.com","Vikas"],
["sharath.shivanna@gmail.com","Sashi"],
["arunsheaven@gmail.com","BPharm"],
["susahu_2006@yahoo.com","Sahu"],
["ishanbanerjee@gmail.com","Ishan"],
["shah.g.gaurav@gmail.com","GShah"],
["vishal.kayship@gmail.com","Vishal"],
["ravikiran.g@gmail.com","Ravikiran"],
["jasho_bose@yahoo.com","Jasho"],
["vbrahmaiah@yahoo.com","Bramhaiah"],
["gferns@yahoo.com","Genevieve"],
["vijaydevatha@gmail.com","Devatha"],
["sundawns@yahoo.com","Prabhat"],


]


password=`cat password.txt`
nameList.each do |entry|
	(name,email)=entry
	#upcaseName=name.upcase
	#`./render "HAPPY DIWALI" #{upcaseName} > hello.pnm`;
	#`pnmtojpeg hello.pnm > hello.jpg`
	#x=Mailer.new
	#x.attach("hello.jpg")
	#x.subject="Happy Diwali #{name}"
	#x.from="ckkashyap@gmail.com"
	#x.to=email
	#x.body=getMessage(name)


	#x.sendGMAIL("ckkashyap",password)
	puts "Done Sending to #{name} #{email}"
end






