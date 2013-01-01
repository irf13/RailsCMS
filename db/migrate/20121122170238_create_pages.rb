class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :subject
        #could also use t.integer "subject_id"
      t.string "name"
      t.string "permalink"
      t.integer "position"
      t.boolean "visible", :default => false
      t.timestamps
    end
    add_index("pages", "subject_id") #always index on foreign key
    add_index("pages", "permalink")
  end
end
