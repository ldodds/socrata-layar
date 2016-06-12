require_relative '../spec_helper'

describe 'SocrataLayer::Client' do
  
  it "gets dataset metadata" do
    client = SocrataLayar::Client.new("data.bathhacked.org")
    VCR.use_cassette 'dataset_metadata' do
      dataset = client.dataset_metadata("uau9-ufy3")
      expect( dataset.id ).to eql("uau9-ufy3")
      expect( dataset.title ).to eql("Public Art Catalogue")
      expect( dataset.columns.size ).to_not eql(0)
      expect( dataset.location_column["name"] ).to eql("Location") 
    end

  end
  
end