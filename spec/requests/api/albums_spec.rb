# frozen_string_literal: true

require 'swagger_helper'

describe 'Albums API' do
  path '/api/v1/albums/{id}' do
    get 'Retrieves an album' do
      tags 'Albums'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [api_auth: {}, user_auth: {}]

      response '200', 'Album found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 release_date: { type: :string, format: 'date' }
               },
               required: %w[id name]

        let(:id) { Album.create(name: 'XYZ', release_date: Date.today).id }
        run_test!
      end

      response '404', 'album not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
