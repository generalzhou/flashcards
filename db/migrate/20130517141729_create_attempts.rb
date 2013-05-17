class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.references :round
      t.references :card
      t.integer    :status, :default => 0
    end
  end
end
