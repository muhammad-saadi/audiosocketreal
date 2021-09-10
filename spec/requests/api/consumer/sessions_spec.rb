require 'swagger_helper'

RSpec.describe 'api/consumer/sessions', type: :request do
  path '/api/v1/consumer/session/signup' do
    post 'Signup a new consumer' do
      tags 'Consumer-Session'

      produces 'application/json'

      parameter name: :email, in: :formData, type: :string
      parameter name: :first_name, in: :formData, type: :string
      parameter name: :last_name, in: :formData, type: :string
      parameter name: :password, in: :formData, type: :string
      parameter name: :password_confirmation, in: :formData, type: :string
      parameter name: :content_type, in: :formData, type: :string

      security [{ api_auth: [] }]

      response '200', 'Sign-up successful' do
        schema type: :object,
               properties: {
                 'auth-token': { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/session' do
    post 'Login a consumer' do
      tags 'Consumer-Session'

      produces 'application/json'

      parameter name: :email, in: :formData, type: :string
      parameter name: :password, in: :formData, type: :string
      parameter name: :remember_me, in: :formData, type: :boolean
      security [{ api_auth: [] }]

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 'auth-token': { type: :string }
               }
        run_test!
      end
    end
  end
end
