require 'swagger_helper'

RSpec.describe 'api/publishers', type: :request do
  path '/api/v1/publishers' do
    get 'Retrieves all publishers of current user' do
      tags 'Publishers'

      produces 'application/json'

      parameter name: :page, in: :query, type: :string
      parameter name: :per_page, in: :query, type: :string
      parameter name: :pagination, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publishers list' do
        schema type: :object,
               properties: {
                 publishers: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       pro: { type: :string },
                       ipi: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/publishers' do
    post 'Create new publishers' do
      tags 'Publishers'

      produces 'application/json'

      parameter name: :name, in: :query, type: :string
      parameter name: :pro, in: :query, type: :string
      parameter name: :ipi, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Created' do
        schema type: :object,
               properties: {
                 publishers: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       pro: { type: :string },
                       ipi: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/publishers/{id}' do
    patch 'Update a publishers' do
      tags 'Publishers'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :name, in: :query, type: :string
      parameter name: :pro, in: :query, type: :string
      parameter name: :ipi, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Updated' do
        schema type: :object,
               properties: {
                 publishers: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       pro: { type: :string },
                       ipi: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/publishers/{id}' do
    delete 'Destroy a publishers' do
      tags 'Publishers'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Updated' do
        schema type: :object,
               properties: {
                 publishers: {
                   type: :array,
                   items: {
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       pro: { type: :string },
                       ipi: { type: :string }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end
end
