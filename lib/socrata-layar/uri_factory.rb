# encoding: utf-8

module SocrataLayar 
  class URIFactory
    
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
          
  end
end
