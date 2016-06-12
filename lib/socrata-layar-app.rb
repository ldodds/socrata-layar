module SocrataLayar
  class App < Sinatra::Base
    
    use Rack::MatrixParams

    configure do |app|      
      set :client, SocrataLayar::Client.new( ENV["SOCRATA_CATALOG"] )
      set :views, settings.root + '/../views' 
      set :public_folder, settings.root + '/../static' 
    end
      
    get "/" do
      erb :index
    end  
                
    get "/dataset/:id" do
      @dataset = settings.client.dataset_metadata( params[:id] )
      @error = "No location column found for this dataset" unless @dataset.location_column != nil
      erb :dataset
    end
    
    get "/layar/:id" do      
      
      dataset_config = default_config.merge( params[ params[:id] ] || {} )
        
      adapter = SocrataLayar::Adapter.new(settings.client)
      pois = settings.client.query_pois( params[:id], params[:lat], params[:lon], params[:radius], dataset_config["field"] )      

                
      content_type "application/json"
      return adapter.convert_to_layar( dataset_config["layerName"], pois, dataset_config ).to_json
        
    end
              
    def default_config
      {
          "title"=>"title",
          "description"=>"description",  
          "field"=>"location",
          "imageURL"=>nil 
      }
    end
    
    not_found do
      'Not Found'
    end 
      
  end
end