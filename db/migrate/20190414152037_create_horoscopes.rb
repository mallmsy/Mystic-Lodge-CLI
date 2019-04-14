class CreateHoroscopes < ActiveRecord::Migration[5.0]
  def change
    create_table :horoscopes do |t|
      t.string :mood
      t.string :horoscope_template
    end
  end
end
