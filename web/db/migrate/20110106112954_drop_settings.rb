class DropSettings < ActiveRecord::Migration
  def self.up
    drop_table :settings
  end

  def self.down
    create_table :settings, :force => true do |t|
      t.string :var, :null => false
      t.text   :value, :null => true
      t.timestamps
    end
    
    add_index :settings, :var, :uniq => true
  end
end
