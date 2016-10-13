class CreateCampains < ActiveRecord::Migration[5.0]
  def change
    create_table :campains do |t|
      t.string :title
      t.text :description
      t.attachment :cover

      t.timestamps
    end
  end
end
