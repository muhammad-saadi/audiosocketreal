require 'swagger_helper'

RSpec.describe 'api/users_agreements', type: :request do
  path '/api/v1/users_agreements' do
    get 'Retrieves agreements details of current user' do
      tags 'Users Agreements'

      parameter name: :role, in: :query, type: :string

      produces 'application/json'

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'UsersAgreements list' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   agreement: { type: :object },
                   status: { type: :string },
                   role: { type: :string },
                   status_updated_at: { type: :string },
                   agreement_user: { type: :string }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/users_agreements/{id}/update_status' do
    patch 'Update status of an users_agreement' do
      tags 'Users Agreements'

      parameter name: :id, in: :path, type: :string
      parameter name: :status, in: :formData, type: :string

      produces 'application/json'

      security [{ api_auth: [] }, { user_auth: [] }]

      response '200', 'Status Updated' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   agreement: { type: :object },
                   status: { type: :string },
                   role: { type: :string },
                   status_updated_at: { type: :string },
                   agreement_user: { type: :string }
                 }
               }

        run_test!
      end
    end
  end
end
