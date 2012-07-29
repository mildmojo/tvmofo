# From http://sachachua.com/blog/2011/05/rails-exporting-data-specific-tables-fixtures/
namespace :db do
  desc "Extract fixtures from DB; provide [table1,table2] to extract only some tables."
  task :extract_fixtures, [:tables] => :environment do |t, args|
    sql  = "SELECT * FROM %s"
    skip_tables = ["schema_info"]
    ActiveRecord::Base.establish_connection
    if ENV['TABLES']
      tables = ENV['TABLES'].split(/, */)
    elsif args[:tables]
      tables = args[:tables].split(/, */)
    else
      tables = ActiveRecord::Base.connection.tables - skip_tables
    end
    if (not ENV['OUTPUT_DIR'])
      output_dir="#{Rails.root}/test/fixtures"
    else
      output_dir = ENV['OUTPUT_DIR'].sub(/\/$/, '')
    end
    (tables).each do |table_name|
      i = "000"
      File.open("#{output_dir}/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) { |hash, record|
          hash["#{table_name}_#{i.succ!}"] = record.except(:id)
          hash
        }.to_yaml
        puts "wrote #{table_name} to #{output_dir}/"
      end
    end
  end
end