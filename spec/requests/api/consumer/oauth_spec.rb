require 'swagger_helper'

RSpec.describe 'api/consumer/oauth', type: :request do
  path '/api/v1/consumer/oauth/google_login' do
    get 'Get google login/signup url' do
      tags 'Consumer-oauth'
      security [{ api_auth: [] }]

      response '200', 'Google URL' do
        schema type: :object,
               properties: {
                 url: { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/oauth/facebook_login' do
    get 'Get facebook login/signup url' do
      tags 'Consumer-oauth'
      security [{ api_auth: [] }]

      response '200', 'Facebook URL' do
        schema type: :object,
               properties: {
                 url: { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/oauth/linkedin_login' do
    get 'Get linkedin login/signup url' do
      tags 'Consumer-oauth'
      security [{ api_auth: [] }]

      response '200', 'Facebook URL' do
        schema type: :object,
               properties: {
                 url: { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/oauth/google_callback' do
    post 'Login with google' do
      tags 'Consumer-oauth'

      parameter name: :code, in: :formData, type: :string

      security [{ api_auth: [] }]

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 auth_token: { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/oauth/facebook_callback' do
    post 'Login with facebook' do
      tags 'Consumer-oauth'

      parameter name: :code, in: :formData, type: :string

      security [{ api_auth: [] }]

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 auth_token: { type: :string }
               }
        run_test!
      end
    end
  end

  path '/api/v1/consumer/oauth/linkedin_callback' do
    post 'Login with linkedin' do
      tags 'Consumer-oauth'

      parameter name: :code, in: :formData, type: :string

      security [{ api_auth: [] }]

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 auth_token: { type: :string }
               }
        run_test!
      end
    end
  end
end
