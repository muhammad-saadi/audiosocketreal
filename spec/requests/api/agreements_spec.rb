require 'swagger_helper'

RSpec.describe 'api/agreements', type: :request do
  path '/api/v1/agreements' do
    get 'Retrieves all agreements of current user' do
      tags 'Agreements'

      produces 'application/json'

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Agreements list' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   content: { type: :string },
                   file: { type: :string },
                   agreement_type: { type: :string }
                 }
               }
        run_test!
      end
    end
  end
end
