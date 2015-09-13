# encoding:UTF-8
require 'nokogiri'
require 'httpclient'
require 'sanitize'
puts "TheIsoZone.com Xbox Game Scraper"
puts "======Welcome ^_^======"

#Get the number of pages
doc = Nokogiri::Slop(open("http://www.theisozone.com/downloads/xbox/xbox-isos/"))

#Get the last page number just before "Next" on the bottom of page 1, and minus one, because computers count funny.
howmanypagestotal = doc.html.body.div[3].div.div.div.div[0].center.div.a[13].content.to_i - 1
totalpages = howmanypagestotal.to_i
totaldl = 0
totalsize = []

#For every page, there are 25 games listed.
gamesinpages = totalpages * 25
puts "\nThere are #{totalpages} Pages, Roughly #{gamesinpages} Games"

#Menu
puts "\nChoices:"
puts "title   Print All Game Titles"
puts "xbdb    Print All Game Titles with TheIsoZone URL"
puts "dall    Print Title, Cover Art URL, IsoZone Description of All Games"
puts "link    [Pick this one!]Get Download links of All Games"
print "Enter: "
input = gets.chomp
puts "\nYou Entered: #{input}"



#Get each page, then search page for games, search games for theisozone.com link
if input == "title"

	#Do this 1 page at a time
	PagesArray = (1..totalpages)
	PagesArray.each do |pages|
			
		#Get the page, print banner
		page = Nokogiri::HTML(open("http://www.theisozone.com/downloads/xbox/xbox-isos/page-#{pages}/"))
		
		
		#Isolate and print each game title
		page.search("a.row_link").each do |game|
			puts "#{Sanitize.fragment("#{game}")}"
		end
	
		
	#End PagesArray
	end





#Print All Game Titles with TheIsoZone URL
elsif input == "xbdb"
	
	#Do this 1 page at a time
	PagesArray = (1..totalpages)
	PagesArray.each do |pages|
			
		#Get the page, print banner
		page = Nokogiri::HTML(open("http://www.theisozone.com/downloads/xbox/xbox-isos/page-#{pages}/"))
		
		#Isolate and print each theisozone link,
		page.search("a.row_link").each do |game|
			
			#Septerate with new line, print game title
			puts ""
			puts "#{Sanitize.fragment("#{game}")}:"
			
			#Get the URL from href=''
			link =  "http://www.theisozone.com/downloads/xbox/xbox-isos#{game["href"]}"
			puts link
		#End page.search
		end
		
	#End PagesArray
	end




#Get Description and Cover Art image URL of All Games
elsif input == "dall"
	
	#Do this 1 page at a time
	PagesArray = (1..totalpages)
	PagesArray.each do |pages|
			
		#Get the page
		page = Nokogiri::HTML(open("http://www.theisozone.com/downloads/xbox/xbox-isos/page-#{pages}/"))
		
		
		
		
		#Isolate and print each theisozone link.
		#Open that link; Search and isolate description in HTML
		page.search("a.row_link").each do |game|
			#Septerate with new line, print game title
			puts ""
			puts "#{Sanitize.fragment("#{game}")}:"
			
			#Get the URL from href=''
			link =  "http://theisozone.com#{game["href"]}"
			puts link
			
			#Open the URL from href=''
			isozonegame = Nokogiri::HTML(open(link))
			 
			
			#The one div element with all the info
			content = isozonegame.css("div.content_row_wrap").first
			
			
			#Get Image URL
			if isozonegame.css("img.content_icon").first == nil
				puts "None"
			else
				puts "Cover: http://www.theisozone.com#{content.at_css("img.content_icon")["src"]}"
			end
			
			
			
			#Get Description
			storenoko = content.to_s
			#Split after cover image
			afterimage = storenoko.split('class="content_icon" style="padding-top:5px;">')
			#Split before <br> in div.content_row_wrap, which is immeditaly after the description
			beforebr = afterimage[1].split("<br>")
			#Exception handling
			if beforebr[0] == nil
			elsif beforebr[0] == "Format:"
			else
				puts beforebr[0]
			#end beforebr
			end
			
		#End page.search
		end
	
	#End PagesArray
	end
elsif input == "link"
		
	#Do this 1 page at a time
	PagesArray = (65..73)
	PagesArray.each do |pages|
		puts pages
		#Get the page
		page = Nokogiri::HTML(open("http://www.theisozone.com/downloads/xbox/xbox-isos/page-#{pages}/"))
		
		
		#Isolate and print each theisozone link.
		#Open that link; Search and isolate description in HTML
		page.search("a.row_link").each do |game|
			#Septerate with new line, print game title
			puts ""
			puts "#{Sanitize.fragment("#{game}")}:"
			
			#Get the URL from href=''
			link =  "http://theisozone.com#{game["href"]}"
			puts link
			
			#Open the URL from href=''
			isozonegame = Nokogiri::HTML(open(link))
			 
			
			#The one div element with all the info
			content = isozonegame.css("div.content_row_wrap").first
			
			
			#Get Image URL
			
			if isozonegame.css("img.content_icon").first == nil
				puts "None"
			else
				puts "Cover: http://www.theisozone.com#{content.at_css("img.content_icon")["src"]}"
			end
			
			
			#Get Download Info
			box = isozonegame.css("div#download_box")
			box.search("form").each do |x|
				puts x['action']
			#end box.search
			end
			
		#End page.search
		end
	
	#End PagesArray
	end
	
#End Control Flow
end
