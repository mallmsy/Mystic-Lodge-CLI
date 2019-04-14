class User < ActiveRecord::Base

  has_many :favorites
  has_many :horoscopes, through: :favorites

end
