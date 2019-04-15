require_relative '../config/environment'

mallory = User.find_by(name: "Mallory")
gino = User.find_by(name: "Gino")
luka = User.find_by(name: "Luka")
#
# sag = Zodiac.find_by(mood: "Sagittarius")
#

# def test
#   mallory.horoscopes.each do |i|
#
#     binding.pry
#   end
# end

### start of welcome screen
def welcome
  system("clear")

  prompt = TTY::Prompt.new

  puts "Words go here totaly."

  welcome_selection = prompt.select("Make a selection.", %w(Login Signup Exit))

  if welcome_selection == 'Login'
    login_menu
  elsif welcome_selection == 'Signup'
    signup_menu
  else
    exit_cli
  end
end
### end of welcome screen

### start of login screen
def login_menu
  system("clear")

  prompt = TTY::Prompt.new
  crystal = prompt.decorate('🔮 ')
  prompt.collect do
    username = key(:name).ask("Enter your username.", required: true)

    if !User.find_by(name: username)
      puts "Sorry bud."
      welcome
    else
      if User.find_by(name: username)
        user_password = key(:password).mask("Enter your password.", required: true, mask: crystal)
        if !User.find_by(password: user_password)
          puts "Sorry, incorrect password. Returning to menu."
          sleep 2
          welcome
        else
          main_menu
        end
      end
    end
  end
end
### end of login screen

### start of signup screen
def signup_menu
  system("clear")

  prompt = TTY::Prompt.new
  crystal = prompt.decorate('🔮 ')
  prompt.collect do

  username = key(:name).ask("Enter a username.", required: true)
    if User.find_by(name: username)
      counter = 3
      until counter == 1 || !User.find_by(name: username)
        puts "Sorry, that username is taken."
        counter -= 1
        username = key(:name).ask("Enter a username. You have #{counter} attempt(s) left.", required: true)
      end
      if counter == 1
        puts "Sorry, those usernames are taken. Take a moment to think of a new one. Returning to menu."
        sleep 2
        welcome
      end
    end
  user_birthyear = key(:birthdate).ask("Enter your birth year. (YYYY)")
  user_password = key(:password).mask("Enter a password.", required: true, mask: crystal)

  #main_menu
  end
end


welcome

#binding.pry

puts "HELLO WORLD"
