
require 'net/http'
require 'uri'


# def get_decks!
# 		#while true
# 			user_input = prompt_user
# 			parse_input(user_input)
# 		#end
# 	end
	
# 	def prompt_user
# 		puts "type an Animal for info Dog,Cat,or Bird"
# 		animal_chosen = $stdin.gets.chomp.downcase
# 		if animal_chosen == "dog"
# 			@url = "http://en.wikipedia.org/wiki/Dog"
# 		elsif animal_chosen == "cat"
# 			@url = "http://en.wikipedia.org/wiki/Cat"
# 		else
# 			puts "we don't have info on that animal yet"
# 		end
# 	end
	

	def get_decks
		@webpage = Page.new("http://www.ruby-doc.org/core-1.9.3/")
		puts "fetching..."
		response = @webpage.fetch!
		display_page_info(response)
	end

	def display_page_info(response)
		doc = Nokogiri::HTML(response.body)
		 "Title: #{@webpage.title(doc)}"
		 "Content: #{@webpage.links(doc)}"
	end

class Page
	attr_reader :uri, :url
	def initialize(url)
		@url = url
		@uri = URI.parse(@url)
	end

	def fetch!
		@response = Net::HTTP.get_response(uri)
	end

	def links(doc)
		doc.search('p.class')
	end
	
	def title(doc)
		doc.search('title').inner_text
	end

	def info(doc)
		doc.search('p')[0..1].inner_text
	end
	
	def length
		@response.body.length
	end

end
