require_relative '../config/environment'

$VERBOSE = nil

# COLOR GUIDE
  # HEADER: .light_blue.bold
  # NARRATOR: .light_yellow
  #PARAGRAPH: none (white default)
  # SELECT MENU: .light_blue.bold, active_color: :cyan

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
  prompt.select("What emotion does this make you feel?".light_blue.bold, %w(Joy Trust Fear Surprise Sadness Disgust Anger Anticipation), active_color: :cyan)
end

def populate_template
  prompt = TTY::Prompt.new

  template_sign = @@current_user.sign
  planet = prompt.ask('Enter your favorite PLANET:'.light_blue.bold, active_color: :cyan)
  noun = prompt.ask('Enter a NOUN (names a person, place, thing, or idea):'.light_blue.bold, active_color: :cyan)
  adjective = prompt.ask('Enter an ADJECTIVE (this gives info about size, shape, age, color, material):'.light_blue.bold, active_color: :cyan)
  verb = prompt.ask('Enter a VERB (describes an action or occurance):'.light_blue.bold, active_color: :cyan)
  adverb = prompt.ask('Enter an ADVERB (this describes a verb or adjective and often end in -ly):'.light_blue.bold, active_color: :cyan)

  completed_template = template_smush(template_sign, planet, adverb, adjective, verb, noun)
  system("clear")
  puts "Creating your horoscope now.".light_yellow
  sleep 3
  system("clear")
  completed_template
end

def updated_template_smush(template_sign, planet, adverb, adjective, verb, noun, favorite_id)
  @@update_template = Horoscope.find_by(id: favorite_id)
  template_text = @@update_template.horoscope_template
  ERB.new(template_text).result(binding)
end

def template_smush(template_sign, planet, adverb, adjective, verb, noun)
  @@random_template = Horoscope.all.sample
  template_text = @@random_template.horoscope_template
  ERB.new(template_text).result(binding)
end

#//// BEGIN PROGRAM //////

# start of welcome screen

def welcome
  system("clear")
  font = TTY::Font.new(:doom)
  puts font.write("Mystic").light_blue
  puts font.write("Lodge").light_blue
  puts ""

  prompt = TTY::Prompt.new

  puts "🌙 🌙".blink + " || W E L C O M E || ".light_blue.bold + "🌙 🌙".blink
  puts ""
  puts "Greetings, Cosmic Travler! Welcome to The Mystic Lodge.".light_yellow
  puts ""
  puts"Enter the lodge to find wisdom and guidance for all of life's questions.".light_yellow
  puts ""

  welcome_selection = prompt.select("What shall we do?".light_blue.bold, %w(Login Signup Exit), active_color: :cyan)

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
    username = key(:name).ask("Tell us your name:".light_blue.bold, active_color: :cyan, required: true)

    if !User.find_by(name: username)
      puts "I'm sorry, traveler. I don't believe we've met. Try again. Returning to the lobby".light_yellow
      sleep 2
      welcome
    else
      if User.find_by(name: username)
        user_password = key(:password).mask("Enter your passcode:".light_blue.bold, required: true, mask: crystal)
        if !User.find_by(password: user_password)
          puts "I'm sorry, traveler. That passcode isn't correct. Please try again. Returning to the lobby.".light_yellow
          sleep 2.5
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

  username = key(:name).ask("Enter a username:".light_blue.bold, active_color: :cyan, required: true)
    if User.find_by(name: username)
      counter = 3
      until counter == 1 || !User.find_by(name: username)
        if counter == 1
          puts "Sorry traveler, those usernames are taken. Take a moment to think of a new one. Returning to the lobby.".light_yellow
          sleep 3
          welcome
        end
        puts "I'm sorry, traveler. That username is taken. Try again.".light_yellow
        counter -= 1
        username = key(:name).ask("Enter a username. You have #{counter} attempt(s) left.".light_yellow, active_color: :cyan, required: true)
      end
    end
  user_birthdate = key(:birthdate).ask("Enter your full birthdate (YYYY/MM/DD):".light_blue.bold, active_color: :cyan)
  bday_boolean = birthdate_validate(user_birthdate)

  if !bday_boolean
    counter = 3
    until bday_boolean
      if counter == 1
        puts "Sorry, travler. That doesn't appear to be a valid date. Take a moment to check your calendar and try again. Returning to the lobby.".light_yellow
        sleep 3
        welcome
      end

      puts "Sorry, travler. That doesn't appear to be a valid date. Please check your format and try again.".light_yellow
      counter -= 1
      user_birthdate = key(:birthdate).ask("Enter your full birthdate (YYYY/MM/DD): You have #{counter} attempt(s) left.".light_yellow)
      bday_boolean = birthdate_validate(user_birthdate)

    end
  end
  user_sign = find_zodiac_sign(user_birthdate)
  user_password = key(:password).mask("Enter a passcode:".light_blue.bold, active_color: :cyan, required: true, mask: crystal)
  @@current_user = User.create(name: username, password: user_password, birthdate: user_birthdate, sign: user_sign)

  main_menu
  end
end
  ### end of signup screen

  ### start of main menu screen
def main_menu
  system("clear")

  puts"Astrology is the ancient science of interpreting how the movements of the planets, stars and other heavenly bodies may impact our lives.".light_yellow
  puts ""

  prompt = TTY::Prompt.new
  main_selection = prompt.select("Choose your own adventure:".light_blue.bold, active_color: :cyan) do |option|
    option.choice 'View Daily Horoscope', 1
    option.choice 'Make My Own Horoscope', 2
    option.choice 'View My Favorites', 3
    option.choice 'Exit', 4
  end

  case main_selection
  when 1
    daily_horoscope
  when 2
    make_horoscope
  when 3
    if @@current_user.favorites.empty?
      system("clear")
      puts "Looks like you don't have any favorites, traveler. Returning to lobby.".light_yellow
      sleep 2
      main_menu
    else
      view_favorites
    end
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
  puts "Ah yes, but of course. I can see that you are a ".light_yellow +  "#{@@current_user.sign}".light_blue.bold + ", #{@@current_user.name}. Your horoscope today is quite intriguing...".light_yellow
  puts ""
  puts fetched_horoscope
  puts ""

  daily_selection = prompt.select("Would you like to save this wisdom?".light_blue.bold, %w(Yes No), active_color: :cyan)

  if daily_selection == "Yes"
    system("clear")
    mood_assignment = mood_menu
    system("clear")
    Favorite.create(user_id: @@current_user.id, saved_horoscope: fetched_horoscope, horoscope_mood: mood_assignment)
    puts "Very insightful, #{@@current_user.name}. We've saved this to your favorites.".light_yellow
    sleep 2
    @@current_user.reload
    main_menu
  else
    system("clear")
    puts "We didn't much like that one either. Returning to the lobby.".light_yellow
    sleep 2
    main_menu
  end
end
### end of daily_horoscope screen

### start of make_horoscope screen

def make_horoscope
  system("clear")
  prompt = TTY::Prompt.new

  puts "Let's create a new horoscope. Enter keywords below.".light_yellow
  puts finished_template = populate_template

  save_template_selection = prompt.select('Would you like to save this wisdom?'.light_blue.bold, %w(Yes No), active_color: :cyan)
  if save_template_selection == "Yes"
    system("clear")
    mood_assignment = mood_menu
    system("clear")
    Favorite.create(user_id: @@current_user.id, horoscope_id: @@random_template.id, saved_horoscope: finished_template, horoscope_mood: mood_assignment)
    puts "Very insightful, #{@@current_user.name}. We've saved this to your favorites.".light_yellow
    sleep 2
    @@current_user.reload
    main_menu
  else
    system("clear")
    puts "We didn't much like that one either. Returning to the lobby.".light_yellow
    sleep 2
    main_menu
  end
end
### end of make_horoscope screen

### start of view_favorites screen
def view_favorites
  system("clear")

  prompt = TTY::Prompt.new
  @@current_user.list_all_favorites

  favorites_selection = prompt.select("What would you like to do?".light_blue.bold, active_color: :cyan) do |fav|
    fav.choice 'Delete A Favorite', 1
    fav.choice 'Update A Favorite', 2
    fav.choice 'View By Mood', 3
    fav.choice 'Main Menu', 4
  end

   case favorites_selection
### START DELETE SECTION
   when 1
    fav_delete_selection = prompt.ask("Which favorite would you like to delete? Enter the number:".light_blue.bold)
      if fav_delete_selection.to_i > @@current_user.favorites.length || fav_delete_selection.to_i == 0
        system("clear")
        puts "That doesn't seem to be a valid selection. Please try again.".light_yellow
        sleep 2
        view_favorites
      end
    del_id = @@current_user.favorites[fav_delete_selection.to_i - 1].id
    Favorite.destroy(del_id)
    system("clear")
    puts "We didn't like that one anyway. Returning to the lobby.".light_yellow
    sleep 2
    @@current_user.reload
    main_menu


   when 2
### START UPDATE SECTION
    fav_update_selection = prompt.ask("Which favorite would you like to update?".light_blue.bold)
    if fav_update_selection.to_i > @@current_user.favorites.length || fav_update_selection.to_i == 0
      system("clear")
      puts "That doesn't seem to be a valid selection. Please try again.".light_yellow
      sleep 2
      view_favorites
    end
    system("clear")
    update_id = @@current_user.favorites[fav_update_selection.to_i - 1].id
    temp_fav = Favorite.find_by(id: update_id)
    if !temp_fav.horoscope_id
      temp_fav_mood_assignment = mood_menu
      fav_to_be_updated = Favorite.find_by(id: update_id)
      fav_to_be_updated.update(horoscope_mood: temp_fav_mood_assignment)
      puts "Oh yes, another profound insight. We've saved this to your favorites. Returning to the lobby.".light_yellow
      sleep 2
      @@current_user.reload
      view_favorites
    else
      prompt = TTY::Prompt.new

      template_sign = @@current_user.sign
      planet = prompt.ask('Enter your favorite PLANET:'.light_blue.bold, active_color: :cyan)
      noun = prompt.ask('Enter a NOUN (names a person, place, thing, or idea):'.light_blue.bold, active_color: :cyan)
      adjective = prompt.ask('Enter an ADJECTIVE (this gives info about size, shape, age, color, material):'.light_blue.bold, active_color: :cyan)
      verb = prompt.ask('Enter a VERB (describes an action or occurance):'.light_blue.bold, active_color: :cyan)
      adverb = prompt.ask('Enter an ADVERB (this describes a verb or adjective and often end in -ly):'.light_blue.bold, active_color: :cyan)

      completed_template = updated_template_smush(template_sign, planet, adverb, adjective, verb, noun, temp_fav.horoscope_id)

      system("clear")
      puts "Updating your horoscope now.".light_yellow
      sleep 3
      system("clear")
      puts completed_template

      save_template_selection = prompt.select('Would you like to save this wisdom?'.light_blue.bold, %w(Yes No), active_color: :cyan)
      if save_template_selection == "Yes"
        system("clear")
        mood_assignment = mood_menu
        system("clear")
        fav_temp_to_be_updated = Favorite.find_by(id: update_id)
        fav_temp_to_be_updated.update(saved_horoscope: completed_template, horoscope_mood: mood_assignment)
        puts "Very insightful, #{@@current_user.name}. We've saved this to your favorites.".light_yellow
        sleep 2
        @@current_user.reload
        main_menu
      else
        system("clear")
        puts "We didn't much like that one either. Returning to the lobby.".light_yellow
        sleep 2
        main_menu
      end
  end

### START VIEW BY MOOD SECTION
   when 3
     system("clear")
     view_by_mood_selection = @@current_user.mood_menu_hash
    if view_by_mood_selection.length == 0
      system("clear")
      puts "You don't have any favorites, traveler. Time to find some. Returning to the lobby.".light_yellow
      sleep 2
      view_favorites
    else
      system("clear")
      temp_mood = prompt.select('Pick a mood to view.'.light_blue.bold, view_by_mood_selection, active_color: :cyan)
      system("clear")
      temp_mood_horo_list = @@current_user.m_list(temp_mood)
      @@current_user.display_mood_list(temp_mood_horo_list)
      post_mood_view = prompt.select("Return To Favorites?".light_blue.bold, %w(Yes), active_color: :cyan)
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
  puts "Thank you for visiting The Mystic Lodge".light_blue
  puts ""
  font = TTY::Font.new(:doom)
  puts font.write("Mystic Lodge").light_blue
  puts ""
  puts "May the great spirit guide you... 💫 ✨ 🌙".light_blue
  sleep 2
  system("clear")
  system("^C")
end

welcome
