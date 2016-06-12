# encoding: utf-8

module SocrataLayar 
  class Client
    
    attr_reader :base
    
    def initialize(base)
      @base = base || ENV["SOCRATA_CATALOG"]
    end
    
    def uri(path)
      return "http://#{@base}/#{path}"
    end
      
    def dataset_home(id)
      return uri("datasets/" + id)
    end  
    
    #Detailed metadata for a dataset, using Socrata JSON format. Includes custom metadata
    def dataset_metadata(id)
      return uri("views/" + id + ".json")
    end
    
    #The default API for the dataset
    def dataset_endpoint(id)
      return uri("resource/" + id)
    end
              
    def query_pois(dataset, lat, lng, radius, field="location")
      response = RestClient.get dataset_endpoint(dataset), {:params => {"$where" => "within_circle(#{field}, #{lat}, #{lng}, #{radius})"} }            
      result = JSON.parse( response.to_str )
      return result
    end
    
  end
  
  
end
