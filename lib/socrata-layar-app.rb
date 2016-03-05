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
      set :config, JSON.parse( File.read(File.dirname(__FILE__) + "/../etc/dataset-layers.json") )      
    end
      
    get "/" do
      "Hello world!"
    end  
        
    get "/layar/:id" do
      @dataset = dataset(params[:id])
      @pois = dataset_pois(params[:id], params[:lat], params[:lon], params[:radius])
      content_type "application/json"
      return convert_to_layar( params[:layerName], @pois, settings.config[params[:id]] ).to_json
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
     
    def convert_to_layar(name, results, config )
      layar = {}
      layar["layer"] = name
      layar["errorString"] = "ok"
      layar["errorCode"] = 0
      hotspots = []
      results.each_with_index do |result, i|
        hotspots << {
          "id" => "#{i}",
          "text" => {
            "title" => field( result, config["title"], "title"),
            "description" => field( result, config["description"], "description")
          },
          "anchor" => {
            "geolocation" => { "lat" => result["location"]["latitude"], "lon" => result["location"]["longitude"] } 
          }          
        }
      end
      layar["hotspots"] = hotspots
      return layar
    end
    
    def field(result, field_name, default)
      return result[field_name] || result[default]
    end
    
    not_found do
      'Not Found'
    end 
      
  end
end