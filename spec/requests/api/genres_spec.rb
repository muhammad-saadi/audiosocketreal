require 'swagger_helper'

RSpec.describe 'api/genres', type: :request do
  path '/api/v1/genres' do
    get 'Get all genres' do
      tags 'Genres'

      security [{ api_auth: [] }]

      produces 'application/json'

      response '200', 'Genres List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string }
                 }
               }
        run_test!
      end
    end
  end
end
