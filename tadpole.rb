require 'discordrb'
require 'json'
require 'htmlentities'
require 'securerandom'
getatoken = "PUT YOUR TOKEN HERE"
getanapp = 224662505157427200 # REPLACE WITH YOUR APPLICATION ID
bot = Discordrb::Commands::CommandBot.new(token: getatoken, application_id: getanapp, prefix: ['tadpole '])
#  ad88888ba  88888888888 888888888888 888888888888 88 888b      88   ,ad8888ba,   ad88888ba 
# d8"     "8b 88               88           88      88 8888b     88  d8"'    `"8b d8"     "8b
# Y8,         88               88           88      88 88 `8b    88 d8'           Y8,        
# `Y8aaaaa,   88aaaaa          88           88      88 88  `8b   88 88            `Y8aaaaa,  
#   `"""""8b, 88"""""          88           88      88 88   `8b  88 88      88888   `"""""8b,
#         `8b 88               88           88      88 88    `8b 88 Y8,        88         `8b
# Y8a     a8P 88               88           88      88 88     `8888  Y8a.    .a88 Y8a     a8P
#  "Y88888P"  88888888888      88           88      88 88      `888   `"Y88888P"   "Y88888P" 

# When turned on, any bot account's messages will be sent throught Tadpole.
@parsebots = false

# The maximum of allowed connections through Tadpole.
@conlimit = 5

# When turned on, all attachments URLs through Tadpole.
@allowattach = true

module Join
  extend Discordrb::EventContainer

  server_create do |event|
  event.bot.send_message(167106306895773697,":email: OAuth joining #{event.server.name} (#{event.server.id})")
  event.bot.send_message(event.server.id,"Hello! I am Tadpole!
I can help connect your channel to any other channel that has me!
If you have any other questions and need support, join this discord server: https://discord.gg/0vjTDaDsgOQWUtlv
To start, type `#tadpole help` in chat.

*Thanks!*")
  end
end
module Tadpole
	extend Discordrb::EventContainer
	message do |event|
		tp = JSON.parse(open('data/tadpole').read)
		tp.each do |con2|
			con = con2[1]
			if not con[1] == nil
				if con.include?(event.channel.id.to_s)
					con.each do |chn|
						if not chn.to_i == event.channel.id
							chn2 = chn
							chn = event.bot.channel(chn.to_i)
							if not chn == nil
								if event.author.bot_account
									if @parsebots
										if not event.channel.private?
											msg = HTMLEntities.new.decode("&#x1F4E1;")+" *##{event.channel.name} `BOT`* **#{event.author.name}:** #{event.message.content}"
										else
											msg = HTMLEntities.new.decode("&#x1F4E1;")+" **#{event.author.name} `BOT`:** #{event.message.content}"
										end
										if event.message.attachments.count > 0 && @allowattach #and bot.bot_user.on(chn.server).permission?(:embed_links, chn)
										att = []
											event.message.attachments.each {|a| att.insert(0, a.url)}
											msg += " "+HTMLEntities.new.decode("&#x1F5BC;")+"**:** "+att.join(" ")
										end
										if msg.length > 1950
											event.author.mention+", Your last message could not be sent because it hit the character limit!"
										else
											chn.send_message(msg)
										end
									end
								else
									if not event.channel.private?
										msg = HTMLEntities.new.decode("&#x1F4E1;")+" *##{event.channel.name}* **#{event.author.name}:** #{event.message.content}"
									else
										msg = HTMLEntities.new.decode("&#x1F4E1;")+" **#{event.author.name}:** #{event.message.content}"
									end
									if event.message.attachments.count > 0 #and bot.bot_user.on(chn.server).permission?(:embed_links, chn)
									att = []
										event.message.attachments.each {|a| att.insert(0, a.url)}
										msg += " "+HTMLEntities.new.decode("&#x1F5BC;")+"**:** "+att.join(" ")
									end
									if msg.length > 2000
										event.author.mention+", Your last message could not be sent because it hit the character limit!"
									else
										chn.send_message(msg)
									end
								end
							else
								tp.delete(chn2)
								IO.write("data/tadpole",tp.to_json)
								nil
							end
						end
					end
				end
			end
		end
	end
end

bot.include! Tadpole
bot.include! Join

tp = JSON.parse(open('data/tadpole').read)
tpc = JSON.parse(open('data/tadpolecs').read)

bot.command :print do |event, *args|
  if not event.user.id == 158049329150427136 then
  event << ":no_entry: This command is only for the developer of the bot!"
  else
  event << "printed to console!"
  print args.join(' ') + '
'
 end
end

bot.command :invite do |event, *args|
  event << "To invite me, use this link,"
  event << "     #{event.bot.invite_url}" + "&permissions=18432"
end

bot.command :host do |event, *args|
	norole = (event.user.roles.any? { |e| e.name.downcase == 'tadpole operator' })
	if norole or event.user.id == 158049329150427136 or event.server.owner.id == event.user.id
	key = SecureRandom.uuid
	red = false
	ways = 2
	if not args[0].to_i < 2
		ways = args[0]
	end
	if ways > @conlimit
		ways = @conlimit
	end
	tp.each do |con2|
		con = con2[1]
		if con.include?(event.channel.id.to_s)
			red = true
		end
	end
	if red then
		HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" You already have a connection!"
	else
		if not tp.has_key?(key) == nil
			HTMLEntities.new.decode("&#x1F6F0;")+" Started a #{ways}-way connection! **Tadpole ID:** **`"+key+"`**"
			tp[key] = [].insert(0, event.channel.id.to_s)
			tpc[key] = ways
			holderval = IO.write("data/tadpole",tp.to_json)
			holderval = IO.write("data/tadpolecs",tpc.to_json)
			nil
		else
			HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" On no! A rare error happened! The bot created a tadpole key that red exists! Please execute the command again!"
		end
	end
	else
	":no_entry: You need to be server owner or have the role `Tadpole Operator`."
	end
end

bot.command :create do |event, *args|
  bot.execute_command(:host, event, args)
end

bot.command :make do |event, *args|
  bot.execute_command(:host, event, args)
end

bot.command :end do |event, *args|
	norole = (event.user.roles.any? { |e| e.name.downcase == 'tadpole operator' })
	if norole or event.user.id == 158049329150427136 or event.server.owner.id == event.user.id
	red = true
	tp.each do |con2|
		con = con2[1]
		if con.include?(event.channel.id.to_s)
			if con.count == 1
				red = false
				event << HTMLEntities.new.decode("&#x1F4DE;")+ " Stopped hosting connection."
				holderval = tp.delete(con2[0])
				holderval = tpc.delete(con2[0])
				holderval = IO.write("data/tadpole",tp.to_json)
				holderval = IO.write("data/tadpolecs",tpc.to_json)
				red = false
			elsif con.count == 2
				chn = event.bot.channel(con.reverse[con.index(event.channel.id.to_s)].to_i)
				red = false
				#event.channel.send_message("Disconnecting... If there is no response after this type `#tadpole end force`")
				if not chn == nil	
					if event.channel.private?
						chn.send_message(HTMLEntities.new.decode("&#x1F4DE;")+" *#{event.author.name} Disconnected.* `Connection has ended.`")
					else
						chn.send_message(HTMLEntities.new.decode("&#x1F4DE;")+" *##{event.channel.name} Disconnected.* `Connection has ended.`")
					end
				end
				event << HTMLEntities.new.decode("&#x1F4DE;")+ " Disconnected."
				holderval = tp.delete(con2[0])
				holderval = tpc.delete(con2[0])
				holderval = IO.write("data/tadpole",tp.to_json)
				holderval = IO.write("data/tadpolecs",tpc.to_json)
			else
				red = false
				#event.channel.send_message("Disconnecting... If there is no response after this type `#tadpole end force`")
				ccon = con
				con.each do |chn|
					chn2 = event.bot.channel(chn)
					if not chn2 == nil
						if event.channel.private?
							chn2.send_message(HTMLEntities.new.decode("&#x1F4DE;")+" *#{event.author.name} Disconnected.*")
						else
							chn2.send_message(HTMLEntities.new.decode("&#x1F4DE;")+" *##{event.channel.name} Disconnected.*")
						end
					else
						ccon.delete(chn)
					end
				end
				event << HTMLEntities.new.decode("&#x1F4DE;")+ " Disconnected."
				ccon.delete(event.channel.id.to_s)
				tp[con2[0]] = ccon
				holderval = IO.write("data/tadpole",tp.to_json)
			end
		end
	end
	if red
		event << HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" There is no connection!"
	end
	else
	event << ":no_entry: You need to be server owner or have the role `Tadpole Operator`."
	end
end

bot.command :disconnect do |event, *args|
  bot.execute_command(:end, event, args)
end

bot.command :leave do |event, *args|
  bot.execute_command(:end, event, args)
end

bot.command :cinfo do |event, *args|
	red = true
	tp.each do |con2|
		con = con2[1]
		if con.include?(event.channel.id.to_s)
			msg = HTMLEntities.new.decode("&#x1F6F0;")+" `Connection Info`\n```diff\n! Tadpole ID: "+con2[0]+"\n! Connected to "+con.count.to_s+"/"+tpc[con2[0]].to_s+" channel(s)."
			con.each do |chn|
				chn2 = event.bot.channel(chn.to_i)
				if not chn2 == nil
					if chn2.private?
						msg += "\n   "+chn2.name+"'s private message channel"
					else
						msg += "\n   #"+chn2.name+" from "+chn2.server.name
					end
				else
					tp[con2[0]].delete(chn) 
				end
				red = false
			end
			IO.write("data/tadpole", tp.to_json)
			msg += "\n```"
			event << msg
		end
	end
	if red 
		event << HTMLEntities.new.decode("&#x1F6F0;")+ " `Connection Info`\n```diff\n- No connection.\n```"
	end
end

bot.command :connectioninfo do |event, *args|
  bot.execute_command(:cinfo, event, args)
end

bot.command :join do |event, *args|
	norole = (event.user.roles.any? { |e| e.name.downcase == 'tadpole operator' })
	if norole or event.user.id == 158049329150427136 or event.server.owner.id == event.user.id
	if not args[0] == ''
	red = false
	tp.each do |con2|
		con = con2[1]
		if con.include?(event.channel.id.to_s)
			red = true
		end
	end
	if red then
		HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" You already have a connection!"
	else
		if tp.has_key?(args[0]) and not tpc[args[0]].to_i <= tp[args[0]].count
			tp[args[0]].each do |chn|
				if event.channel.private?
					bot.channel(chn.to_i).send_message(HTMLEntities.new.decode("&#x1F6F0;&#x2705;")+" A channel connected! **"+event.author.name+"**'s private message channel")
				else
					bot.channel(chn.to_i).send_message(HTMLEntities.new.decode("&#x1F6F0;&#x2705;")+" A channel connected! **#"+event.channel.name+"** from **"+event.server.name+"**")
				end
			end
			event << HTMLEntities.new.decode("&#x1F6F0;&#x2705;")+" Found a connection ! You are now connected to "+tp[args[0]].count.to_s+" other server(s)!"
			tp[args[0]].insert(0,event.channel.id.to_s)
			IO.write("data/tadpole",tp.to_json)
		elsif tp.has_key?(args[0]) and tpc[args[0]].to_i <= tp[args[0]].count
			HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" That connection has reached its connecting limit!"
		else
			HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" No available connection with that Tadpole ID was found!"
		end
	end
	else
		event << HTMLEntities.new.decode("&#x1F6F0;&#x1F6AB;")+" No argument was found!"
	end
	else
	event << ":no_entry: You need to be server owner or have the role `Tadpole Operator`."
	end
end

bot.command :connect do |event, *args|
  bot.execute_command(:join, event, args)
end

bot.command :botinfo do |event, *args|
  lsc = 0
  ls = bot.servers.values.each {|s| if s.large; lsc+=1; end }
  ss = bot.servers.count - lsc
  event << "```diff"
  event << "! Bot Info"
  event << "-   #{bot.servers.count} servers"
  event << "+     #{lsc} large servers"
  event << "+     #{ss} small servers"
  event << "-   #{bot.users.count} unique users."
  event << "-   #{tp.count} connections."
  event << "```"
end

bot.command :help do |event|
  event << "I sent you a list, #{event.user.mention} !"
  event.user.pm("Prefixes: `@Tadpole` `Tadpole` `#tadpole`
__**Available Commands**__
**ping** *~ AKA pong*

__***Commands only available to Server Owner or with anyone with the role `Tadpole Operator`***__
**host [server limit]** *~ Starts a connection and prints the Tadpole ID. AKA make, create*
**join (tadpole id)** *~ Joins a connection. AKA connect*
**end** *~ Ends a connection and prints the Tadpole ID. AKA disconnect, leave*
**connectioninfo** *~ Gets connection info. AKA cinfo*

If you have any questions, join this discord server: https://discord.gg/0vjTDaDsgOQWUtlv")
end

bot.command :ping do |event, *args|
  mtsfn = Time.now - event.message.timestamp
  event << "**Pong!** Here are the stats:"
  event << "From now to message time stamp: "+mtsfn.to_s+" seconds."
end

bot.command :pong do |event, *args|
  mtsfn = Time.now - event.message.timestamp
  event << "**Ping!** Here are the stats:"
  event << "From now to message time stamp: "+mtsfn+" seconds."
end
bot.run :async
bot.game=("with connections")
#bot.send_message(167106306895773697,":desktop: Rebooted!")
bot.sync
=begin
