require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /index' do
    it 'user一覧ページを表示' do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.create(:other_user)
      get '/v1/users'
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # ユーザー数が正しいか確認
      expect((json.length)).to eq(2)
      # ユーザー名が正しいか確認
      expect(json[0]['name']).to eq(user.name)
      expect(json[0]['name']).to_not eq(other_user.name)
      # ユーザー名が正しくないか確認
      expect(json[1]['name']).to eq(other_user.name)
      expect(json[1]['name']).to_not eq(user.name)
    end
  end

  describe 'GET /show' do
    it 'user詳細ページを表示' do
      user = FactoryBot.create(:user)
      get "/v1/users/#{user.id}"
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # 値が正しいか確認
      expect(json['user']['name']).to eq(user.name)
      expect(json['user']['email']).to eq(user.email)
    end
  end
end