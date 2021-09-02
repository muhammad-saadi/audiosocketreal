require 'swagger_helper'

RSpec.describe 'api/aims', type: :request do
  path '/api/v1/aims_api/track_response' do
    post 'Aims Track Response' do
      tags 'Aims Api'

      parameter name: :'aims_api[id_client]', in: :formData, type: :string
      parameter name: :'aims_api[id]', in: :formData, type: :string
      parameter name: :'aims_api[status]', in: :formData, type: :string
      parameter name: :'aims_api[process_input_error_details]', in: :formData, type: :string

      produces 'application/json'

      response '200', 'Track Response Sent' do
        schema type: :object,
               properties: {
                 status: { type: :string }
               }

        run_test!
      end
    end
  end
end
