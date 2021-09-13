require 'swagger_helper'

RSpec.describe 'api/consumer/tracks', type: :request do
  path '/api/v1/consumer/tracks' do
    get 'Get' do
      tags 'Consumers-Tracks'
      produces 'application/json'

      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string
      parameter name: :search_key, in: :query, type: :string
      parameter name: :search_query, in: :query, type: :string
      parameter name: :order_by, in: :query, type: :string

      security [{ api_auth: [] }, { consumer_auth: [] }]

      response '200', 'Tracks List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   file: { type: :string },
                   public_domain: { type: :string },
                   created_at: { type: :string },
                   lyrics: { type: :string },
                   explicit: { type: :boolean },
                   composer: { type: :string },
                   description: { type: :string },
                   language: { type: :string },
                   instrumental: { type: :boolean },
                   key: { type: :string },
                   bpm: { type: :string },
                   admin_note: { type: :string },
                   genre: {
                     type: :array,
                     items: :object
                   },
                   filters: {
                     type: :array,
                     items: :object
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/tracks/{id}' do
    get 'Get' do
      tags 'Consumers-Tracks'
      produces 'application/json'

      security [{ api_auth: [] }, { consumer_auth: [] }]

      parameter name: :id, in: :path, type: :string

      response '200', 'Track' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 file: { type: :string },
                 public_domain: { type: :string },
                 created_at: { type: :string },
                 lyrics: { type: :string },
                 explicit: { type: :boolean },
                 composer: { type: :string },
                 description: { type: :string },
                 language: { type: :string },
                 instrumental: { type: :boolean },
                 key: { type: :string },
                 bpm: { type: :string },
                 admin_note: { type: :string },
                 genre: {
                   type: :array,
                   items: :object
                 },
                 filters: {
                   type: :array,
                   items: :object
                 }
               }
        run_test!
      end
    end
  end
end
