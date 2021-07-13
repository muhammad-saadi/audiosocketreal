require 'swagger_helper'

RSpec.describe 'api/filters', type: :request do
  path '/api/v1/filters' do
    get 'Get all filters' do
      tags 'Filters'

      security [{ api_auth: [] }]

      produces 'application/json'

      response '200', 'Filters List' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   sub_filters: {
                     type: :array,
                     items: { type: :object }
                   }
                 }
               }
        run_test!
      end
    end
  end
end
