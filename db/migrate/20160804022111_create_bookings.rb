class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
    	t.belongs_to :listing
    	t.belongs_to :user
    	t.date :startdate
    	t.date :enddate
    	t.integer :guest

      t.timestamps null: false
    end
  end
end
