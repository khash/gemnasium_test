require 'httparty'
require 'json'

class Gemnasium
  
  # timeout of 0 waits for the results indefinately
  def self.evaluate(gemfile, gemfile_lock, timeout = 0)
    auth = {:username => "X", :password => ENV['GEMNASIUM_API_KEY'] }
    dependencies = [ { :name => 'Gemfile', :content => gemfile }, { :name => 'Gemfile.lock', :content => gemfile_lock }]

    load = { :body => { :dependency_files => dependencies }.to_json, :basic_auth => auth }
    load.merge!({ :timeout => timeout }) if timeout != 0
  
    begin
      response = HTTParty.post("https://gemnasium.com/api/v2/evaluate_status", load)
      
      if response.code != 200
        raise "Received #{response.code} from Gemnasium: #{response.message}"
      else
        return { :status => response.parsed_response['status'] }
      end
    rescue Timeout::Error
      puts "Gemnasium API call timedout" 
      return { :status => :unknown }
    rescue => exc
      puts "Gemnasium API call failed #{exc} at #{exc.backtrace.join("\n")}" 
      return { :status => :unknown }
    end
  end
end