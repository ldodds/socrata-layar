# encoding: utf-8

module SocrataLayar 
  class Client
    
    attr_reader :base
    
    def initialize(base)
      @base = base || ENV["SOCRATA_CATALOG"]
    end
    
    def uri(path)
      "http://#{@base}/#{path}"
    end
      
    def dataset_home(id)
      uri("datasets/" + id)
    end  
    
    #Detailed metadata for a dataset, using Socrata JSON format. Includes custom metadata
    def dataset_metadata_url(id)
      uri("views/" + id + ".json")
    end
    
    def dataset_metadata(id)
      response = RestClient.get dataset_metadata_url(id)
      return SocrataLayar::Dataset.new( JSON.parse( response.to_str ) ) 
    end
    
    #The default API for the dataset
    def dataset_endpoint(id)
      uri("resource/" + id)
    end
              
    def query_pois(dataset, lat, lng, radius, field="location")
      response = RestClient.get dataset_endpoint(dataset), {:params => {"$where" => "within_circle(#{field}, #{lat}, #{lng}, #{radius})"} }            
      return JSON.parse( response.to_str )
    end
    
  end
  
  
end
