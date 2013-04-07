#

require "rubygems"
require "active_record"
module DataDbPopulate
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

   File.open("processedData.csv", "r").readlines.each do |project_info_line|
	  
	     
	     puts project_info_line
	     project_info_array = project_info_line.split(",")
	     #puts project_info_array[0].class
	     project_bio,project_developer,project_city = nil
	     #project_developer = ProjectDeveloper.find_or_create_by(name: project_info_array[1], status: 'Active') unless project_info_array[1].nil?
	     #project_city = City.find_or_create_by(name: project_info_array[4]) unless project_info_array[4].nil?
	     #project_bio = Project.find_or_create_by(name: project_info_array[0], status: 'Active', projectType: project_info_array[3], projectLocation: project_info_array[2]) unless project_info_array[0].nil?
	     unless project_info_array[1].nil?
            project_developer = ProjectDeveloper.where(name: project_info_array[1]).first
            project_developer = ProjectDeveloper.create(name: project_info_array[1], status: 'Active') if project_developer.nil?
	     end	
	     unless project_info_array[4].nil?
            project_city = City.where(name: project_info_array[4]).first
            project_city = City.create(name: project_info_array[4]) if project_city.nil?
	     end	
	     unless project_info_array[0].nil?
            project_bio = Project.where(name: project_info_array[0]).first
            project_bio = Project.create(name: project_info_array[0], status: 'Active', projectType: project_info_array[3], projectLocation: project_info_array[2])
	     end	
	     project_bio.city = project_city
	     project_bio.project_developer = project_developer
	     project_developer.projects << project_bio
	     project_bio.save
	     project_city.save
	     project_developer.save         
	   	
   end
end   