# This migration comes from spree_id_verification (originally 20200828144231)
class AddStatusToUsers < ActiveRecord::Migration[5.1]
  def up
    # unless Rails.env.test?
    #   execute <<-SQL
    #     CREATE TYPE spree_user_status AS ENUM ('pending', 'rejected', 'verified');
    #   SQL

    #   add_column :spree_users, :status, :spree_user_status, default: 'pending'
    #   add_index :spree_users, :status
    # else
    add_column :spree_users, :status, :integer
    # end
  end

  def down
    # unless Rails.env.test?
    #   remove_column :spree_users, :status

    #   execute <<-SQL
    #       DROP TYPE spree_user_status;
    #   SQL
    # else
    remove_column :spree_users, :status
    # end
  end
end
