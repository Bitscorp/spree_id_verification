class CreateSpreeIdVerificationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_id_verification_images do |t|
      t.integer :attachment_width
      t.integer :attachment_height
      t.integer :attachment_file_size
      t.integer :position, index: true
      t.string :attachment_content_type
      t.string :attachment_file_name
      t.string :type, limit: 75
      t.datetime :attachment_updated_at
      t.text :alt

      t.integer :user_id, null: false, index: true

      t.timestamps null: false, precision: 6
    end
  end
end
