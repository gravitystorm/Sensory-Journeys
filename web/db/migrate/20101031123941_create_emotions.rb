class CreateEmotions < ActiveRecord::Migration
  def self.up
    create_table :emotions do |t|
      t.string :text
      t.string :icon
      t.references :project

      t.timestamps
    end

    add_column :markers, :emotion_id, :integer
    remove_column :markers, :emotion
  end

  def self.down
    drop_table :emotions

    remove_column :markers, :emotion_id
    add_column :markers, :emotion, :string
  end
end
