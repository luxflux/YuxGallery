class CreatePhotoJobs < ActiveRecord::Migration
  def change
    create_table :photo_jobs do |t|
      t.references :job, :scan
      t.string :state

      t.timestamps
    end
  end
end
