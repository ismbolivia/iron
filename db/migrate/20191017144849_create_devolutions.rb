class CreateDevolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :devolutions do |t|
      t.integer :sale_id
      t.integer :sale_detail_id
      t.integer :qty
      t.decimal :mount
      t.text :obs

      t.timestamps
    end
  end
end
