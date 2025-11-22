class AddReasonToEncouragements < ActiveRecord::Migration[7.1]
  def change
    add_column :encouragements, :reason, :string
  end
end
