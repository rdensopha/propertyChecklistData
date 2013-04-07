=begin
gem install ruby-postgres # need to use this
ActiveRecord::Base.establish_connection(:adapter => "postgresql",
:database => "test", :username => "kevin", :password => "test")
=end
require "rubygems"
require "active_record"
module PopulateScript
   ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'propertychecklist_development',
      username: 'postgres',
      password: 'root',
      host: 'localhost',
      port: 5433)
   # Model to be used..
   class Project < ActiveRecord::Base
      belongs_to :project_developer
      belongs_to :city
   end
   class ProjectDeveloper < ActiveRecord::Base
      has_many :projects
   end
   class City < ActiveRecord::Base
      
   end   
   Dir.glob("mb*") do |filename|
      entries_hash = {}
      File.open(filename, "r") do |fileContent|
         project_info =[]      
         fileContent.read.split(/",\n/).each { |project_data| project_info << project_data}
         project_info.delete_at(0) # delete the first element #project_info - #project_type
         project_info.each do |content|
            temp_project_each = content.split /","/
            key = temp_project_each[0].sub(/"/, '')
            value = temp_project_each[1].gsub(/\r/,'')
            entries_hash[key] = value
         end      	
      end
      entries_hash.each do |key, value|
         project_info_array = []
         temp_project_info = key.split(/by/)
         project_info_array << temp_project_info[0].strip unless temp_project_info[0].nil?
         project_info_array << temp_project_info[1].strip unless temp_project_info[1].nil?
         project_locality = nil
         project_type_info = nil
         project_city = nil

         temp_value_array = value.split(/,/)
         temp_value_array.each do |array_value|
            unless array_value.match(/\sin\s/).nil?
              project_info_array << array_value.split(/in/)[1].strip
              project_info_array << temp_value_array[0..temp_value_array.find_index(array_value)-1].join('')
              project_info_array << temp_value_array[temp_value_array.find_index(array_value)+1].strip.split(/\s/)[0] unless temp_value_array[temp_value_array.find_index(array_value)+1].nil?
            end
         end
         File.open("processedData.csv", "a"){ |file_handle| file_handle.puts project_info_array.join(',')}   
      end   
   end
end   
