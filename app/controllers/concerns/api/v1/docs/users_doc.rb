module Api::V1::Docs::UsersDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_list_managers do
      api :GET, '/v1/users/managers', 'List all users with manager role'
    end

    def_param_group :doc_accept_invitation do
      api :PATCH, '/v1/users/accept_invitation', 'Accept invitation by setting password'
      param :token, String, desc: 'Encoded id of the user', required: true
      param :password, String, desc: 'Password to be set', required: true
      param :password_confirmation, String, desc: 'Confirmation of password', required: true
    end

    def_param_group :doc_authenticate_token do
      api :GET, '/v1/users/authenticate_token', 'Authenticated given token and send status of user'
      param :token, String, desc: 'Encoded id of the user', required: true
    end
  end
end