class CreateTagMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_maps do |t|

      t.references :book
      t.references :tag
      t.timestamps
    end
  end
end
