class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.boolean :profile_type1
      t.boolean :profile_type2
      t.string :screen_name
      t.string :prefecture
      t.string :city
      t.text :about_region
      t.text :immigration_support
      t.text :job
      t.text :skill
      t.text :interest
      t.text :other1
      t.text :other2
      t.integer :public_status_id
      
      t.timestamps
    end
  end
end
