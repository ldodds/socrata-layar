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
      config = settings.config[params[:id]] || {}
      return convert_to_layar( params[:layerName], @pois, config ).to_json
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
     
    #http://www.bathnes.gov.uk/sites/default/files/publicart/
    def convert_to_layar(name, results, config )
      layar = {}
      layar["layer"] = name
      layar["errorString"] = "ok"
      layar["errorCode"] = 0,
      layar["showBiwOnClick"] = true
      hotspots = []
      results.each_with_index do |result, i|
        hotspots << {
          "id" => field_value( result, config["id"], "#{i}"),
          "text" => {
            "title" => field( result, config["title"], "title"),
            "description" => field( result, config["description"], "description")
          },
          "anchor" => {
            "geolocation" => { "lat" => result["location"]["latitude"], "lon" => result["location"]["longitude"] } 
          },
          "imageURL" => image_field_value(result, config["imageURL"], nil)       
        }
      end
      layar["hotspots"] = hotspots
      return layar
    end
    
    def field(result, field_name, default_field)
      return result[field_name] || result[default_field]
    end

    def field_value(result, field_name, default)
      return result[field_name] || default
    end

    def image_field_value(result, field_name, default)
      val = result[field_name]
      return val["url"] if val
      return default
    end
        
    not_found do
      'Not Found'
    end 
      
  end
end