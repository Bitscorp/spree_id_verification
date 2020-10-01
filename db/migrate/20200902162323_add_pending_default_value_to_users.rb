class AddPendingDefaultValueToUsers < ActiveRecord::Migration[5.1]
  def up
    ::Spree::User.update_all(status: 'verified')
  end

  def down
  end
end
