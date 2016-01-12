require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Use the parent directory to name our project
PROJECT_NAME = File.basename(%x(pwd)).strip.downcase
WEBSERVER_NAME = PROJECT_NAME + "-webserver"
CUCUMBER_NAME = PROJECT_NAME + "-cucumber"

namespace "docker" do
  namespace "build" do      
    desc "Build the primary app Docker image"
    task :app do
      sh "docker build -t #{WEBSERVER_NAME} ."
    end

    desc "Build the Docker image for running Cucumber tests"
    # build the main app image before building the cucumber image
    task :cucumber => 'docker:build:app' do 
      sh "docker build -t #{CUCUMBER_NAME} -f Dockerfile.cucumber ." 
    end
  end
  
  namespace "server" do

    desc "Start a persistant default Rails server in a docker container"
    # build the main app image before running the server
    task :start => 'docker:build:app' do      
      sh "docker run --name #{WEBSERVER_NAME} -d -p 3000:3000 #{WEBSERVER_NAME}"
    end
  
    desc "Stop the Rails server previously started by docker:server:start"
    task :stop do      
      begin      
        sh "docker stop #{WEBSERVER_NAME}"
        sh "docker rm #{WEBSERVER_NAME}"
      rescue => e
        puts "Task docker:server:stop failed"
        puts "#{e.class}: #{e.message}"
      end   
    end    
  end
  
  namespace "test" do 
      desc "Build and run the Cucumber tests in the test environment ran by 'docker:environment:test"
      task :cucumber => ['docker:build:cucumber','docker:server:start'] do
            
        test_failed = false
      
        begin        
          sh "docker run -i -t --rm --link #{WEBSERVER_NAME}:localhost #{CUCUMBER_NAME}"
        rescue => e
          # a failing test throws an exception, but that doesn't mean the task failed. Record the failing test and continue
          test_failed = true
          puts "Task docker:build:cucumber failed"
          puts "#{e.class}: #{e.message}"
        end
   
        # Teardown the running server
        Rake::Task['docker:server:stop'].invoke

        if test_failed
          fail "[FAILED]"
        else
          puts "[OK]"
        end
      end
    end
end