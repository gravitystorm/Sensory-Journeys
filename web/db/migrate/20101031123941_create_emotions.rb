class CreateEmotions < ActiveRecord::Migration
  def self.up
    create_table :emotions do |t|
      t.string :text
      t.string :icon
      t.references :project

      t.timestamps
    end

    execute("insert into emotions (\"text\", icon, project_id, created_at, updated_at) values ('happy', 'positive.png', 1, now(), now())")
    execute("insert into emotions (\"text\", icon, project_id, created_at, updated_at) values ('neutral', 'neutral.png', 1, now(), now())")
    execute("insert into emotions (\"text\", icon, project_id, created_at, updated_at) values ('sad', 'negative.png', 1, now(), now())")

    add_column :markers, :emotion_id, :integer
    execute("update markers set emotion_id = 1 where emotion = 'happy'")
    execute("update markers set emotion_id = 2 where emotion = 'neutral'")
    execute("update markers set emotion_id = 3 where emotion = 'sad'")
    remove_column :markers, :emotion
  end

  def self.down
    drop_table :emotions

    add_column :markers, :emotion, :string
    execute("update markers set emotion = 'happy' where emotion_id = 1")
    execute("update markers set emotion = 'neutral' where emotion_id = 2")
    execute("update markers set emotion = 'sad' where emotion_id = 3")
    remove_column :markers, :emotion_id
  end
end
