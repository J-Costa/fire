class CreateCertificates < ActiveRecord::Migration[8.1]
  def change
    create_enum :certificate_status, %w[active expired revoked]

    create_table :certificates do |t|
      t.string :code
      t.references :enrollment, null: false, foreign_key: true
      t.datetime :issued_at
      t.datetime :expires_at
      t.enum :status, enum_type: :certificate_status, null: false

      t.timestamps
    end

    add_index :certificates, :code, unique: true
  end
end
