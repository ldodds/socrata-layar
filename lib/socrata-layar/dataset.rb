module SocrataLayar
  class Dataset
    attr_reader :location_column
    
    def initialize(metadata)
      @metadata = metadata
      find_first_geo_column
    end
    
    def id
      return @metadata["id"]
    end
    
    def title
      return @metadata["name"]
    end
    
    def find_first_geo_column
      @metadata["columns"].each do |column|
        if column["dataTypeName"] == "location"
          @location_column = column
          return
        end
      end
    end
    
    def columns
      @metadata["columns"]
    end
  end
end