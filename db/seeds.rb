Favorite.destroy_all
User.destroy_all
Horoscope.destroy_all

Favorite.reset_pk_sequence
User.reset_pk_sequence
Horoscope.reset_pk_sequence

mallory = User.create(name: "Mallory", password: "password", birthdate: "1988-12-15", sign: "Sagittarius")
gino = User.create(name: "Gino", password: "password", birthdate: "1991-06-28", sign: "Cancer")
luka = User.create(name: "Luka", password: "password", birthdate: "1993-02-01", sign: "Aquarius")

# #

Horoscope.create(horoscope_template: "Greetings, <%=template_sign%>. You are apt to feel a major shift this week as <%=planet%> links with Libra. You will begin to attract new <%=noun%> who will expand your horizons and further your growth. <%=planet%> will <%=adverb%> add <%=adjective%> to your house of partnerships during this period so that it will be the time to consider your options: <%=verb%>, marry, or form a business alliance.")

Horoscope.create(horoscope_template: "Hello, dear <%=template_sign%>. Flexibility will likely be a key factor regarding <%=noun%> or other matters. You’ll likely need to hold off on a final agreement, as <%=planet%> is in conflict with <%=template_sign%>. Still, have all <%=adjective%> questions ready and <%=verb%> intently. This will make your experience go <%=adverb%>.")

Horoscope.create(horoscope_template: "Be prepared, <%=template_sign%>. As Pluto perfectly links with <%=planet%>, a message you send on social media may go viral. This may involve your passion for a <%=noun%> and your eloquence and drive can cause you to <%=verb%> <%=adverb%> into a leadership role. Seize every opportunity to spread your <%=adjective%> message.")

Horoscope.create(horoscope_template: "Take heed, <%=template_sign%>. As Mercury dances with <%=planet%>, you’ll likely receive <%=adjective%> news about something close to your heart. But a simple <%=noun%> might be overlooked as Mercury’s retrograde <%=adverb%> disrupts order. Once Mercury moves direct you’ll begin to see steady <%=verb%>. If you need a special favor, remain gentle yet direct, and you’ll likely be blessed with loyal support.")

Horoscope.create(horoscope_template: "Choose your words carefully, dear <%=template_sign%>, when you give a promise or favor to someone close to you. That will help make your <%=noun%> clearly understood. You may need to <%=verb%> <%=adverb%> , and that will require <%=adjective%> trust, so take your time. If you know where you stand, let <%=planet%> assure you that it will be more than enough to ensure you arrive at the same page with a loyal ally.")

Horoscope.create(horoscope_template: "A new <%=noun%> can open a door for you, dear <%=template_sign%>, thanks to Mercury’s waltz with <%=planet%>. Stay abreast with all that transpires, for you may have an opportunity to <%=verb%> that will give you excellent public exposure. If you keep your focus, and your feet on the ground, someone close to you may give you <%=adjective%> advice to be heeded <%=adverb%>.")

Horoscope.create(horoscope_template: "You may find an important missing <%=noun%>, as <%=planet%> harmonizes with Pluto. You may be delighted to find that it includes <%=adjective%> information you’ve been looking for. Now is the time to <%=verb%> with confidence, dear <%=template_sign%>. If you need information fast, your grandparents or a distant relative will likely be a godsend. Use their wisdom <%=adverb%>!")

Horoscope.create(horoscope_template: "Mental endurance will be important for you, <%=template_sign%>, as Jupiter (the planet of the mind) joins forces with <%=planet%>. You’ll be faced with a choice regarding <%=noun%> and looking <%=adverb%> to the long-term will be advantageous. You may need to <%=verb%> a trusted friend or other expert, for you may discover a mistake that requires <%=adjective%> advice.")
