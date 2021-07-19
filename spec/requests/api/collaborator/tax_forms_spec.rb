require 'swagger_helper'

RSpec.describe 'api/collaborator/tax_forms', type: :request do
  path '/api/v1/collaborator/tax_forms/create_tax_form' do
    post 'Create a new form' do
      tags 'Collaborator-Tax Forms'

      parameter name: :artist_id, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      produces 'application/json'

      response '200', 'Tax Form Created' do
        schema type: :object,
               properties: {
                 url: { type: :string }
               }

        run_test!
      end
    end
  end
end
