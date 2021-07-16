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

  path '/api/v1/tax_forms/submit_tax_form' do
    post 'Generate pdf of tax form' do
      tags 'Tax Forms'

      parameter name: :'form[token]', in: :formData, type: :string
      parameter name: :'form[reference]', in: :formData, type: :string

      response '200', 'Tax Form Submitted' do
        run_test!
      end
    end
  end
end
