class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :horoscope_id
      t.string :saved_horoscope
      t.string :horoscope_mood
    end
  end
end
