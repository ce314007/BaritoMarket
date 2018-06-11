require 'rails_helper'

RSpec.describe 'App API', type: :request do
  describe 'Profile API' do
    let(:headers) do
      { 'ACCEPT' => 'application/json', 'HTTP_ACCEPT' => 'application/json' }
    end

    it 'should return profile information of registered app' do
      app = create(:barito_app)
      app_updated_at = app.updated_at.strftime(Figaro.env.timestamp_format)
      get api_profile_path, params: { token: app.secret_key }, headers: headers
      json_response = JSON.parse(response.body)
      %w[name app_group tps_config cluster_name consul_host app_status].each do |key|
        expect(json_response.key?(key)).to eq(true)
        expect(json_response[key]).to eq(app.send(key.to_sym))
      end
      expect(json_response.key?('updated_at')).to eq(true)
      expect(json_response['updated_at']).to eq(app_updated_at)
    end

    it 'should return 401 for invalid token' do
      secret_key = SecureRandom.uuid.gsub(/\-/, '')
      error_msg = "Unauthorized: #{secret_key} is not a valid App Token"
      get api_profile_path, params: { token: secret_key }, headers: headers
      json_response = JSON.parse(response.body)
      expect(json_response['code']).to eq(401)
      expect(json_response['errors']).to eq([error_msg])
    end

    it 'should return 422, when token is not provided' do
      error_msg = 'Invalid Params: token is a required parameter'
      get api_profile_path, params: { token: '' }, headers: headers
      json_response = JSON.parse(response.body)
      expect(json_response['code']).to eq(422)
      expect(json_response['errors']).to eq([error_msg])
    end
  end

  describe 'Profile by Cluster Name API' do
    let(:headers) do
      { 'ACCEPT' => 'application/json', 'HTTP_ACCEPT' => 'application/json' }
    end
    
    it 'should return profile information of registered app when supplied cluster name' do
      app = create(:barito_app)
      app_updated_at = app.updated_at.strftime(Figaro.env.timestamp_format)
      get api_profile_by_cluster_name_path, 
        params: { cluster_name: app.cluster_name }, 
        headers: headers
      json_response = JSON.parse(response.body)
      %w[name app_group tps_config cluster_name consul_host app_status].each do |key|
        expect(json_response.key?(key)).to eq(true)
        expect(json_response[key]).to eq(app.send(key.to_sym))
      end
      expect(json_response.key?('updated_at')).to eq(true)
      expect(json_response['updated_at']).to eq(app_updated_at)
    end
  end
end
