class AddAdminsToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :admins, :string, array: true, default: []
  end
end
