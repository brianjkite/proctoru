class AddTables < ActiveRecord::Migration[6.1]
  def change
    create_table :users  do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, limit: 10, null: false
      t.timestamps
    end

    create_table :colleges do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :exams do |t|
      t.string :title, null: false
      t.json :questions
      t.belongs_to :exam_window
      t.belongs_to :college
      t.timestamps
    end

    add_index :exams, :exam_window

    create_table :exams_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :exam
    end

    create_table :exam_windows do |t|
      t.date :start_time_window, null: false
      t.date :end_time_window, null: false
      t.timestamps
    end

    create_table :api_requests do |t|
      t.string :type, null: false
      t.belongs_to :users
      t.json "params"
      t.json "errors"
      t.timestamps
    end

    create_table "audits", force: :cascade do |t|
      t.string  "model"
      t.json   "data"
      t.timestamps
    end
  end
end
