require_relative '../config/environment'

$VERBOSE = nil

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

def mood_menu
  prompt = TTY::Prompt.new
  prompt.select("What does this horoscope make you feel?", %w(Joy Trust Fear Surprise Sadness Disgust Anger Anticipation))
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
      puts "Sorry bud, that's not a username. Try again."
      sleep 2
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
    system("clear")
    mood_assignment = mood_menu
    system("clear")
    Favorite.create(user_id: @@current_user.id, saved_horoscope: fetched_horoscope, horoscope_mood: mood_assignment)
    puts "How insightful, #{@@current_user.name}. We've saved this to your favorites."
    sleep 2
    @@current_user.reload
    main_menu
  else
    system("clear")
    puts "Returning to menu."
    sleep 2
    main_menu
  end
  #binding.pry
    #Favorite.create(user_id: mallory.id, horoscope_id: happy.id)
end
### end of daily_horoscope screen

### start of view_favorites screen
def view_favorites
  system("clear")



  prompt = TTY::Prompt.new
  @@current_user.list_all_favorites

  favorites_selection = prompt.select("What would you like to do?") do |fav|
    fav.choice 'Delete A Favorite', 1
    fav.choice 'Update A Favorite', 2
    fav.choice 'View By Mood', 3
    fav.choice 'Main Menu', 4
  end

   case favorites_selection
### START DELETE SECTION
   when 1
    fav_delete_selection = prompt.ask("Which favorite would you like to delete? Enter the number:")
    del_id = @@current_user.favorites[fav_delete_selection.to_i - 1].id
    Favorite.destroy(del_id)
    systme("clear")
    puts "We didn't like that one anyway. Returning to menu."
    sleep 2
    @@current_user.reload
    main_menu
   when 2
### START UPDATE SECTION
    fav_update_selection = prompt.ask("Which favorite would you like to update?")
    system("clear")
    update_id = @@current_user.favorites[fav_update_selection.to_i - 1].id
    update_choices = prompt.select("How do you want to update?") do |up_choice|
      up_choice.choice 'New Daily', 1
      up_choice.choice 'Create New', 2
    end

    case update_choices
    when 1
       system("clear")
       temp_daily = @@current_user.h_daily
       puts temp_daily
       daily_update_selection = prompt.select("Do you want to save?", %w(Yes No))
       if daily_update_selection == "Yes"
         system("clear")
         temp_mood_assignment = mood_menu
         system("clear")
         favorite_to_be_updated = Favorite.find_by(id: update_id)
         favorite_to_be_updated.update(saved_horoscope: temp_daily, horoscope_mood: temp_mood_assignment)
         puts "Oh yes, we like that one too. Returning to menu."
         sleep 2
         @@current_user.reload
         view_favorites
       else
         system("clear")
         puts "Nevermind. Returning to menu."
         sleep 2
         view_favorites
       end
    end
### START VIEW BY MOOD SECTION
   when 3
     system("clear")
     view_by_mood_selection = @@current_user.mood_menu_hash
    if view_by_mood_selection.length == 0
      system("clear")
      puts "Looks like you don't have any favorites. Returning to menu."
      sleep 2
      view_favorites
    else
      system("clear")
      temp_mood = prompt.select('Pick a mood to view.', view_by_mood_selection)
      system("clear")
      temp_mood_horo_list = @@current_user.m_list(temp_mood)
      @@current_user.display_mood_list(temp_mood_horo_list)
      post_mood_view = prompt.select("Head Back To Favorites?", %w(Yes))
      if post_mood_view == "Yes"
        view_favorites
      end
    end
   when 4
    main_menu
   end
end
### end of view_favorites screen

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
