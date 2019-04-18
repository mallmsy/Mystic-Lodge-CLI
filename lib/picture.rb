class Picture

def moon
  art = puts <<-'EOF'
                            +
            ---====D                        @
   o                 ,,*:*::,.__     *
                * ,)))*))))* __.=-.             o
        |       ,((*((a a))-'
       -O-    ,))))))\ = /                     =( =     +
  +     |    ,(((*(((()-(               *
             *))))))/    `\
             (((*}(//(_|_)\\                        .
             )*))))\\*).( //            +  .
    *        (((((*(// / )/                   |
              ))))))/ / /`                   -O-     @
  +           `(*(((/ /`                      |
            o  `)))*))`\            *
                 `((((  `-.__     ,      .
       .            *)-._    `--~jgs`
   @                +    `~---~~`                *

               *       .            o         +



EOF
 art
 end


 def aries
   art = puts <<-'EOF'
   .__.
   [__]._.* _  __
   |  |[  |(/,_)


 EOF
 art
 end


 def taurus
   art = puts <<-'EOF'
   .___.
     |   _.. .._.. . __
     |  (_](_|[  (_|_)



  EOF
  art
  end

def gemini
  art = puts <<-'EOF'
   .__
   [ __ _ ._ _ *._ *
   [_./(/,[ | )|[ )|




  EOF
  art
  end

  def cancer
    art = puts <<-'EOF'
    __
   /  ` _.._  _. _ ._.
   \__.(_][ )(_.(/,[



EOF
art
end

def leo
  art = puts <<-'EOF'
   .
   |    _  _
   |___(/,(_)



EOF
art
end

def sagittarius
  art = puts <<-'EOF'

    __.        ,  ,
   (__  _. _ *-+--+- _.._.*. . __
   .__)(_](_]| |  | (_][  |(_|_)
          ._|



EOF
art
end

def virgo
  art = puts <<-'EOF'
   .  .
   \  /*._. _  _
    \/ |[  (_](_)
           ._|



EOF
art
end

def aquarius
  art = puts <<-'EOF'

   .__.
   [__] _.. . _.._.*. . __
   |  |(_](_|(_][  |(_|_)
         |



EOF
art
end

def pisces
  art = puts <<-'EOF'
   .__
   [__)* __ _. _  __
   |   |_) (_.(/,_)



EOF
art
end

def libra
  art = puts <<-'EOF'
   .    .
   |   *|_ ._. _.
   |___|[_)[  (_]



EOF
art
end

def scorpio
  art = puts <<-'EOF'
    __.
   (__  _. _ ._.._ * _
   .__)(_.(_)[  [_)|(_)
                |


EOF
art
end

def capricorn
  art = puts <<-'EOF'
    __
   /  ` _.._ ._.* _. _ ._.._
   \__.(_][_)[  |(_.(_)[  [ )
          |



EOF
art
end

 def self.display
   pic = Picture.new
   pic.moon
 end

def self.display_sign(sign)
  pic = Picture.new
  case sign
  when "Sagittarius"
    pic.sagittarius

  when "Capricorn"
    pic.capricorn

  when "Scorpio"
    pic.scorpio

  when "Libra"
    pic.libra

  when "Virgo"
    pic.virgo

  when "Leo"
    pic.leo

  when "Cancer"
    pic.cancer

  when "Gemini"
    pic.gemini

  when "Taurus"
    pic.taurus

  when "Aries"
    pic.aries

  when "Pisces"
    pic.pisces

  when "Aquarius"
    pic.aquarius
  end


end

end
