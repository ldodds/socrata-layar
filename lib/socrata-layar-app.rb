require 'sinatra'
require 'sinatra/base'
require 'json'
require 'dotenv'
require 'rest-client'

Dotenv.load

module SocrataLayar
  class App < Sinatra::Base
    
    helpers do
      set :uris, SocrataLayar::URIFactory.new(ENV["SOCRATA_CATALOG"])
    end 
    
    #Configure application level options
    configure do |app|
    end
      
    get "/" do
      "Hello world!"
    end  
        
    get "/layar/:id" do
      puts params[:id]
      @dataset = dataset(params[:id])
      @pois = dataset_pois(params[:id], params[:lat], params[:lon], params[:radius])
      return convert_to_layar( params[:layerName], @pois ).to_json
    end
          
    def dataset(id)
      response = RestClient.get settings.uris.dataset_metadata(id)
      return JSON.parse( response.to_str )
    end 
    
    def dataset_pois(dataset, lat, lng, radius, field="location")
      response = RestClient.get settings.uris.dataset_endpoint(dataset), {:params => {"$where" => "within_circle(location, #{lat}, #{lng}, #{radius})"} }    
      result = JSON.parse( response.to_str )
      return result
    end 
     
    def convert_to_layar(name, results, title="bintype", description="locationdescription")
      layar = {}
      layar["layer"] = name
      hotspots = []
      results.each_with_index do |result, i|
        hotspots << {
          "id" => "#{i}",
          "title" => result[title],
          "description" => result[description],
          "anchor" => {
            "geolocation" => { "lat" => result["location"]["latitude"], "lon" => result["location"]["longitude"] } 
          }
        }
      end
      layar["hotspots"] = hotspots
      return layar
    end
    
    not_found do
      'Not Found'
    end
      
  end
end