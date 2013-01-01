require 'net/http'
require 'json'
require 'date'

class DemoController < ApplicationController
  
  layout 'admin'
  
  Member = Struct.new(:id, :name, :rideCount, :elevTotal, :elevAvg)
  def index
    #Default: template matching the action name
    #render(:action => 'hello')     this is deprecated
    #render(:template -> 'hello')
    #render(:'demo/hello')
    #render('hello')
    
    #redirect_to(:controller => 'demo', :action => 'other_hello')
    #redirect_to(:action => 'other_hello')
  end
  
  def hello
    #redirect_to("http://www.google.com")
    array = Array.new
    monthStart = Date.today.strftime("%Y-%m-01") 
    monthEnd = (Date.today >> 1).strftime("%Y-%m-01") 
    
    @array = [1,2,3,4,5]
    @id = params[:id].to_i
    @page = params[:page].to_i
    
    strava_api = StravaApiHelper["www.strava.com"] 
  
    # members = strava_api.get("clubs/1/members")["members"]
    # members.each do |m|
    #   member = Member.new()
    #   member[:id] = m['id']
    #   puts "Athlete #{member[:id]}"
    #   member[:name] = m['name']
    #   array.push(member)
    #  end 
    #  rides = strava_api.get(member, "rides", 
    #           :startDate => monthStart, :endDate => monthEnd)['rides']
    #  
    #  @temp = rides.class
    memberThreads = []
    members = strava_api.get("clubs/1/members")["members"]
    members.each do |m|
      memberThreads << Thread.new(m['id']){|temp|
      member = Member.new()
      member[:id] = temp
      #puts "Athlete #{member[:id]}"
      member[:name] = m['name']
      member[:rideCount] = 0
      member[:elevTotal] = 0.0
      rides = strava_api.get("rides", :athleteId => member[:id], 
              :startDate => monthStart, :endDate => monthEnd)['rides']
      #puts("\t#{rides.length}")
      threads = []
      rides.each do |r|
        threads<< Thread.new(r['id']){|myPage| 
          elevation = strava_api.get("rides/#{myPage}")['ride']['elevationGain']
          member[:elevTotal] += elevation
          member[:rideCount] += 1
          #puts "\tRide: #{member[:elevTotal]}"
        }
      end
      
      threads.each do |aThread|
         aThread.join
      end
      
      if(member[:rideCount] == 0)
        member[:elevAvg] = 0
      else
        member[:elevAvg] = member[:elevTotal] / member[:rideCount]
      end
      array.push(member)
    }
    end
    memberThreads.each do |bThread|
      bThread.join
    end
    
    array.sort!{ |a, b| b[:elevTotal] <=> a[:elevTotal]}
    
    array.each do |a|
      puts "Rider #{a[:id]}: #{a[:elevTotal]}"
    end
    
    @temp = array[2][:elevTotal]
  end
  
  # def hello
  #   #redirect_to("http://www.google.com")
  #   array = Array.new
  #   monthStart = Date.today.strftime("%Y-%m-01") 
  #   monthEnd = (Date.today >> 1).strftime("%Y-%m-01") 
  #   
  #   @array = [1,2,3,4,5]
  #   @id = params[:id].to_i
  #   @page = params[:page].to_i
  #   
  #   strava_api = StravaApiHelper["www.strava.com"] 
  #   
  #   # members = strava_api.get("clubs/1/members")["members"]
  #   # members.each do |m|
  #   #   member = Member.new()
  #   #   member[:id] = m['id']
  #   #   puts "Athlete #{member[:id]}"
  #   #   member[:name] = m['name']
  #   #   array.push(member)
  #   #  end 
  #   #  rides = strava_api.get(member, "rides", 
  #   #           :startDate => monthStart, :endDate => monthEnd)['rides']
  #   #  
  #   #  @temp = rides.class
  #   
  #   members = strava_api.get("clubs/1/members")["members"]
  #       members.each do |m|
  #         member = Member.new()
  #         member[:id] = m['id']
  #         puts "Athlete #{member[:id]}"
  #         member[:name] = m['name']
  #         member[:rideCount] = 0
  #         member[:elevTotal] = 0.0
  #         rides = strava_api.get("rides", :athleteId => member[:id], 
  #                 :startDate => monthStart, :endDate => monthEnd)['rides']
  #         puts("\t#{rides.length}")
  #         threads = []
  #         rides.each do |r|
  #           threads<< Thread.new(r['id']){|myPage| 
  #             elevation = strava_api.get("rides/#{myPage}")['ride']['elevationGain']
  #             member[:elevTotal] += elevation
  #             member[:rideCount] += 1
  #             puts "\tRide: #{member[:elevTotal]}"
  #           }
  #         end
  #         
  #         threads.each do |aThread|
  #            aThread.join
  #         end
  #         puts 
  #         
  #           
  #         
  #         
  #         #sleep(1) until (member[:rideCount] == rides.length)
  #         member[:elevAvg] = member[:elevTotal] / member[:rideCount]
  #         array.push(member)
  #   end
  #       
  #   @temp = array[1][:elevTotal]
  # end
  
  def other_hello
    render(:text => 'Hello everyone!')
  end
  
  def javascript
  end 
    
  def text_helpers
  end
end

# # a little api helper 
# class StravaApiHelper < Struct.new(:base_url)
#   def get(service, params = {})
#  
#     url = "http://#{self.base_url or "www.strava.com"}/api/v1/#{service}"
#     # escape strings and format dates and times
#     
#     params.each_pair do |k, v|
#       params[k] = URI.escape(v) if v.is_a? String
#       params[k] = v.strftime("%Y-%m-%d") if v.is_a? Date
#       params[k] = v.strftime("%Y-%m-%dT%H:%M:%S") if v.is_a? Time
#     end
#     url << "?#{params.map{|k, v| "#{k}=#{v}"}.join("&")}" if !params.empty?
#     #url = URI.parse(url)
#     request = Typhoeus::Request.new(url);
#     response = request.run
#     JSON.parse( response.body)
#     #JSON.parse(Net::HTTP.get(URI.parse(url)))
#   end
#   
#   def getP()
#     hydra = Typhoeus.Hydra.new
#     requests = Array.new
#     returnData = Array.new
#     
#     url = "http://#{self.base_url or "www.strava.com"}/api/v1/#{service}"
#     # escape strings and format dates and times
#     
#     params.each_pair do |k, v|
#       params[k] = URI.escape(v) if v.is_a? String
#       params[k] = v.strftime("%Y-%m-%d") if v.is_a? Date
#       params[k] = v.strftime("%Y-%m-%dT%H:%M:%S") if v.is_a? Time
#     end
#     url << "?#{params.map{|k, v| "#{k}=#{v}"}.join("&")}" if !params.empty?
#     
#     array.each do |a|
#       request = Typhoes::Request.new(url + "&athleteId=#{member[:id]}"))
#       request.on_complete{}
#       requests.push(request);
#       hydra.queue(requests.last);
#     end
#     
#     hydra.run;
#     
#     requests.each do |r|
#       returnData.push(r.response.body)
#     
#     
#   end
# end


# a little api helper 
class StravaApiHelper < Struct.new(:base_url)
  def get(service, params = {})
 
    url = "http://#{self.base_url or "www.strava.com"}/api/v1/#{service}"
    # escape strings and format dates and times
    
    params.each_pair do |k, v|
      params[k] = URI.escape(v) if v.is_a? String
      params[k] = v.strftime("%Y-%m-%d") if v.is_a? Date
      params[k] = v.strftime("%Y-%m-%dT%H:%M:%S") if v.is_a? Time
    end
    url << "?#{params.map{|k, v| "#{k}=#{v}"}.join("&")}" if !params.empty?
    #url = URI.parse(url)
    # request = Typhoeus::Request.new(url);
    # response = request.run
    # JSON.parse( response.body)
    JSON.parse(Net::HTTP.get(URI.parse(url)))
  end
end
