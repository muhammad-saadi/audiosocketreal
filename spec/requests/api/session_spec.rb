require 'swagger_helper'

RSpec.describe 'api/session', type: :request do
  path '/api/v1/session' do
    post 'create' do
      tags 'Session'

      parameter name: :email, in: :formData, type: :string
      parameter name: :password, in: :formData, type: :string
      parameter name: :remember_me, in: :formData, type: :boolean
      parameter name: :role, in: :formData, type: :string

      # here
      security [api_auth: {}]

      consumes 'multipart/form-data'
      produces 'application/json'

      response '200', 'created' do
        schema type: :object,
               properties: {
                 'auth-token': { type: :string },
                 role: { type: :string }
               }
        run_test!
      end
    end
  end
end
