class User < ActiveRecord::Base

  has_many :favorites
  has_many :horoscopes, through: :favorites

  def m_list(mood_name)
    self.horoscopes.select do |i|
      i.mood.downcase == mood_name.downcase
    end
  end

  def m_list_uniq
    self.horoscopes.map do |i|
      i.mood
    end.uniq
  end

  def h_daily

    sun_sign = self.sign.downcase

    source = Nokogiri::HTML(open("https://www.astrology.com/horoscope/daily/#{sun_sign}.html"))
    s_parse = source.css("main p").first.text

    #response_string = RestClient.get("http://theastrologer-api.herokuapp.com/api/horoscope/#{sun_sign}/today")
    #response_hash = JSON.parse(response_string)

    #url = Nokogiri::HTML(open("http://theastrologer-api.herokuapp.com/api/horoscope/#{sun_sign}/today"))
    #url_hash = JSON.parse(url)

    binding.pry


    return s_parse
  end

#test_html('pisces')

end
