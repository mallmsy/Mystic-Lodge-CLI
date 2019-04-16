class User < ActiveRecord::Base

  has_many :favorites
  has_many :horoscopes, through: :favorites



  def m_list(mood_name)
    self.favorites.select do |horo|
      horo.horoscope_mood == mood_name
      end
  end

  def display_mood_list(temp_mood_list)
      temp_mood_list.each_with_index do |h_scope, ind|
      puts "#{ind + 1}. Mood: #{h_scope.horoscope_mood}"
      puts "#{h_scope.saved_horoscope}"
      puts ""
      end
  end



  def m_list_uniq
    self.favorites.map do |i|
      i.horoscope_mood
    end.uniq
  end


  def mood_menu_hash
    mm_hash = {}
    self.m_list_uniq.each do |mood|
      mm_hash[mood] = mood
    end
    mm_hash
  end

  def h_daily

    sun_sign = self.sign.downcase

    source = Nokogiri::HTML(open("https://www.astrology.com/horoscope/daily/#{sun_sign}.html"))
    s_parse = source.css("main p").first.text

    #response_string = RestClient.get("http://theastrologer-api.herokuapp.com/api/horoscope/#{sun_sign}/today")
    #response_hash = JSON.parse(response_string)

    #url = Nokogiri::HTML(open("http://theastrologer-api.herokuapp.com/api/horoscope/#{sun_sign}/today"))
    #url_hash = JSON.parse(url)
    return s_parse
  end

  def list_all_favorites
    self.favorites.each_with_index do |h_scope, ind|
      puts "#{ind + 1}. Mood: #{h_scope.horoscope_mood}"
      puts "#{h_scope.saved_horoscope}"
      puts ""
      end
  end

end
