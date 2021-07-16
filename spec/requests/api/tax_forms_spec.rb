require 'swagger_helper'

RSpec.describe 'api/tax_forms', type: :request do
  path '/api/v1/tax_forms/create_tax_form' do
    post 'Create a new form' do
      tags 'Tax Forms'

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
