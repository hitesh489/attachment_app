class CreatePublicLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :public_links do |t|
      t.string :key, index: true
      t.timestamp :expire_at, index: true
      t.references :attachment, null: false, foreign_key: true
      t.timestamps
    end
  end
end
