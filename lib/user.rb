class User < ActiveRecord::Base

  has_many :favorites
  has_many :horoscopes, through: :favorites

# generates a list of moods from a specific user's horoscopes
  def m_list(mood_name)
    self.favorites.select do |horo|
      horo.horoscope_mood == mood_name
      end
  end

# displays horoscope with list order and mood
  def display_mood_list(temp_mood_list)
      temp_mood_list.each_with_index do |h_scope, ind|
      puts "#{ind + 1}. Mood: #{h_scope.horoscope_mood}"
      puts "#{h_scope.saved_horoscope}"
      puts ""
      end
  end

# creates unique list of moods for a specific user's horoscopes
  def m_list_uniq
    self.favorites.map do |i|
      i.horoscope_mood
    end.uniq
  end

# creates a hash of available moods for a given user's horoscopes
  def mood_menu_hash
    mm_hash = {}
    self.m_list_uniq.each do |mood|
      mm_hash[mood] = mood
    end
    mm_hash
  end

# scrapes daily horoscope for given user based on zodiac sign
  def h_daily
    sun_sign = self.sign.downcase
    source = Nokogiri::HTML(open("https://www.astrology.com/horoscope/daily/#{sun_sign}.html"))
    s_parse = source.css("main p").first.text
    return s_parse
  end

# displays all horoscopes for a specific user formatted with list order and mood
  def list_all_favorites
    self.favorites.each_with_index do |h_scope, ind|
      puts "#{ind + 1}. Mood: #{h_scope.horoscope_mood}"
      puts "#{h_scope.saved_horoscope}"
      puts ""
      end
  end
end
