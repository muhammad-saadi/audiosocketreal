require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  path '/api/v1/users/managers' do
    get 'List all users with manager role' do
      tags 'Users'

      produces 'application/json'

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Managers list' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   email: { type: :string },
                   first_name: { type: :string },
                   last_name: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/users/forgot_password' do
    post 'Send password reset request' do
      tags 'Users'

      parameter name: :email, in: :formData, type: :string

      produces 'application/json'

      security [{ api_auth: [] }]

      response '200', 'Email Sent' do
        run_test!
      end
    end
  end
end
