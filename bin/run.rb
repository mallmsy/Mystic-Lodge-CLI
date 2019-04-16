require_relative '../config/environment'

#$VERBOSE = nil

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
def birthdate_validate(birthdate)
  bday_split = birthdate.split("/")
  return Date.valid_date?(bday_split[0].to_i,bday_split[1].to_i,bday_split[2].to_i)
end

def find_zodiac_sign(birthdate)
  bday_split = birthdate.split("/")
  return Date.new(bday_split[0].to_i,bday_split[1].to_i,bday_split[2].to_i).zodiac_sign
end

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
          @@current_user = User.find_by(name: username)
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
  user_birthdate = key(:birthdate).ask("Enter your birth year. (YYYY/MM/DD)")
  bday_boolean = birthdate_validate(user_birthdate)

  if !bday_boolean
    counter = 3
    until bday_boolean
      if counter == 1
        puts "Sorry, that doesn't appear to be a valid date. Take a moment to check your calendar and try again. Returning to menu."
        sleep 2
        welcome
      end

      puts "Oops! That doesn't appear to be a valid date. Please check your format and try again."
      counter -= 1
      user_birthdate = key(:birthdate).ask("Enter your birth year. (YYYY/MM/DD). You have #{counter} attempt(s) left.")
      bday_boolean = birthdate_validate(user_birthdate)

    end
  end
  user_sign = find_zodiac_sign(user_birthdate)
  user_password = key(:password).mask("Enter a password.", required: true, mask: crystal)
  @@current_user = User.create(name: username, password: user_password, birthdate: user_birthdate, sign: user_sign)

  main_menu
  end
end
  ### end of signup screen

  ### start of main menu screen
def main_menu
  system("clear")

  prompt = TTY::Prompt.new
  main_selection = prompt.select("Pick your poison") do |option|
    option.choice 'View Daily Horoscope', 1
    option.choice 'Make Your Own Horoscope', 2
    option.choice 'View Your Favorites', 3
    option.choice 'Exit', 4
  end

  case main_selection
  when 1
    daily_horoscope
  when 2
    make_horoscope
  when 3
    view_favorites
  when 4
    exit_cli
  end
end
### end of main menu screen

### start of daily_horoscope screen
def daily_horoscope
  system("clear")

  prompt = TTY::Prompt.new

  fetched_horoscope = @@current_user.h_daily

  puts "Hey #{@@current_user.name} I see that you are a #{@@current_user.sign}. Here is your current horoscope of the day."
  puts ""
  puts fetched_horoscope
  puts ""

  daily_selection = prompt.select("Do you want to save?", %w(Yes No))

  if daily_selection == "Yes"
    mood_assignment = prompt.ask("Give your horoscope a mood.")
    Favorite.create(user_id: @@current_user.id, saved_horoscope: fetched_horoscope, horoscope_mood: mood_assignment)
    puts "How insightful, #{@@current_user.name}. We've saved this to your favorites."
    sleep 2
    main_menu
  else
    puts "Returning to menu."
    sleep 2
    main_menu
  end
  #binding.pry
    #Favorite.create(user_id: mallory.id, horoscope_id: happy.id)
end
### end of daily_horoscope screen

### start of exit screen

def exit_cli
  system("clear")
  puts "May the great spirit guide you... 💫 ✨ 🌙"
  sleep 2
  system("clear")
  system("^C")
end

welcome

#binding.pry

puts "HELLO WORLD"
