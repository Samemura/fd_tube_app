class CreateS3files < ActiveRecord::Migration[6.1]
  def change
    create_table :s3files do |t|
      t.string :key

      t.timestamps
    end
  end
end
