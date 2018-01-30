# A simple REST client for the CSA application. Note that this
# example will only support the user accounts feature. Clearly
# the passwords should not be sent in plain text, but rather HTTPS used.
# Also the password info should go in a config file and accessed as ebvironment
# variables.
# @author Chris Loftus
require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSARestClientForum

  #@@DOMAIN = 'https://csa-web-service-cloftus.c9users.io'
  @@DOMAIN = 'http://localhost:3000'

  def run_menu
    loop do
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'Displaying posts:'
          display_posts
        when '2'
          puts 'Creating post:'
          create_post
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  def display_menu
    puts 'Enter option: '
    puts '1. Display posts'
    puts '2. Create new post'
    puts 'Q. Quit'
  end

  def display_posts
    begin
      response = RestClient.get "#{@@DOMAIN}/api/posts.json?all", authorization_hash

      puts "Response code: #{response.code}"
      puts "Response cookies:\n #{response.cookies}\n\n"
      puts "Response headers:\n #{response.headers}\n\n"
      puts "Response content:\n #{response.to_str}"

      js = JSON response.body
      js.each do |item_hash|
        item_hash.each do |k, v|
          puts "#{k}: #{v}"
        end
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def create_post
    begin
      print "Title: "
      title = STDIN.gets.chomp
      print "Body: "
      body = STDIN.gets.chomp
      print "Post anonymously? (y/n): "
      is_anon = STDIN.gets.chomp.upcase == 'Y' ? '1' : '0'


      # Rails will reject this unless you configure the cross_forgery_request check to
      # a null_session in the receiving controller. This is because we are not sending
      # an authenticity token. Rails by default will only send the token with forms /users/new and
      # /users/1/edit and REST clients don't get those.
      # We could perhaps arrange to send this on a previous
      # request but we would then have to have an initial call (a kind of login perhaps).
      # This will automatically send as a multi-part request because we are adding a
      # File object.
      response = RestClient.post "#{@@DOMAIN}/api/posts.json",

                                 {
                                     post: {
                                         title: title,
                                         body: body,
                                         is_anon: is_anon,
                                     }
                                 }, authorization_hash

      if (response.code == 201)
        puts "Created successfully"
      end
      puts "URL for new resource: #{response.headers[:location]}"
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}"}
  end


end

client = CSARestClientForum.new
client.run_menu
