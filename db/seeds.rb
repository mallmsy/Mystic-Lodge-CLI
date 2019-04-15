Favorite.destroy_all
User.destroy_all
Horoscope.destroy_all

Favorite.reset_pk_sequence
User.reset_pk_sequence
Horoscope.reset_pk_sequence

mallory = User.create(name: "Mallory", birthdate: "1988-12-15", sign: "Sagittarius")
gino = User.create(name: "Gino", birthdate: "1991-06-28", sign: "Cancer")
luka = User.create(name: "Luka", birthdate: "1993-02-01", sign: "Aquarius")
# #
# #
love = Horoscope.create(mood: "Love", horoscope_template: "Here's your horoscope, Leo!")
happy = Horoscope.create(mood: "Happy", horoscope_template: "Here's your horoscope, Sag!")
anger1 = Horoscope.create(mood: "Anger", horoscope_template: "Here's your horoscope, Cancer!")
anger2 = Horoscope.create(mood: "Anger", horoscope_template: "Here's your horoscope again, Cancer!")


# #
Favorite.create(user_id: mallory.id, horoscope_id: happy.id)
Favorite.create(user_id: mallory.id, horoscope_id: anger1.id)
Favorite.create(user_id: mallory.id, horoscope_id: anger2.id)
