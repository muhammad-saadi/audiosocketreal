require 'swagger_helper'

RSpec.describe 'api/collaborator/publishers', type: :request do
  path '/api/v1/collaborator/publishers' do
    get 'Retrieves all publishers of current artist' do
      tags 'Collaborator-Publishers'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
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

  path '/api/v1/collaborator/publishers' do
    post 'Create new publishers' do
      tags 'Collaborator-Publishers'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :name, in: :query, type: :string
      parameter name: :pro, in: :query, type: :string
      parameter name: :ipi, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Created' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   pro: { type: :string },
                   ipi: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/collaborator/publishers/{id}' do
    patch 'Update a publishers' do
      tags 'Collaborator-Publishers'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :name, in: :query, type: :string
      parameter name: :pro, in: :query, type: :string
      parameter name: :ipi, in: :query, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Updated' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   pro: { type: :string },
                   ipi: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/collaborator/publishers/{id}' do
    delete 'Destroy a publishers' do
      tags 'Collaborator-Publishers'

      produces 'application/json'

      parameter name: :artist_id, in: :query, type: :string
      parameter name: :id, in: :path, type: :string

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Publisher Destroyed' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   pro: { type: :string },
                   ipi: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
