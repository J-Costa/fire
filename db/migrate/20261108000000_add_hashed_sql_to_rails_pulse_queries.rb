require 'digest'

class AddHashedSqlToRailsPulseQueries < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:rails_pulse_queries)

    add_column :rails_pulse_queries, :hashed_sql, :string, limit: 32 unless column_exists?(:rails_pulse_queries, :hashed_sql)

    rows = connection.select_all('SELECT id, normalized_sql FROM rails_pulse_queries WHERE hashed_sql IS NULL')
    rows.each do |row|
      hashed_sql = Digest::MD5.hexdigest(row.fetch('normalized_sql'))
      execute <<~SQL
        UPDATE rails_pulse_queries
        SET hashed_sql = #{connection.quote(hashed_sql)}
        WHERE id = #{connection.quote(row.fetch('id'))}
      SQL
    end

    add_index :rails_pulse_queries, :hashed_sql, unique: true, name: 'index_rails_pulse_queries_on_hashed_sql' unless index_exists?(:rails_pulse_queries, :hashed_sql, name: 'index_rails_pulse_queries_on_hashed_sql')
    change_column_null :rails_pulse_queries, :hashed_sql, false
  end

  def down
    remove_index :rails_pulse_queries, name: 'index_rails_pulse_queries_on_hashed_sql' if index_exists?(:rails_pulse_queries, :hashed_sql, name: 'index_rails_pulse_queries_on_hashed_sql')
    remove_column :rails_pulse_queries, :hashed_sql if column_exists?(:rails_pulse_queries, :hashed_sql)
  end
end
