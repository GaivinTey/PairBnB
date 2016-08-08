class CreateAvailableDates < ActiveRecord::Migration
  def change
    create_table :available_dates do |t|
    	t.belongs_to :listing
    	t.date :date
    	t.boolean :availability

      t.timestamps null: false
    end
  end
end
