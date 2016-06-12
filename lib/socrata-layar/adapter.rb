module SocrataLayar 
  class Adapter
        
    def initialize(client)
      @client = client
    end
    
    def convert_to_layar(name, results, config )
      layar = {}
      layar["layer"] = name
      layar["errorString"] = "ok"
      layar["errorCode"] = 0
      hotspots = []
      results.each_with_index do |result, i|
        hotspots << {
          "id" => field_value( result, config["id"], "#{i}"),
          "showBiwOnClick" => true,  
          "text" => {
            "title" => field_value( result, config["title"]),
            "description" => field_value( result, config["description"])
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
    
    def field_value(result, field_name, default="")
      return result[field_name] || default
    end

    def image_field_value(result, field_name, default=nil)
      val = result[field_name]
      return val["url"] if val
      return default
    end
        
  end
end