class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.string :skills
      t.references :recruiter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
