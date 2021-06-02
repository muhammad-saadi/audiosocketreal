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
      param :role, String, desc: 'Role to login as', required: true
    end

    def_param_group :doc_authenticate_token do
      api :GET, '/v1/users/authenticate_token', 'Authenticated given token and send status of user'
      param :token, String, desc: 'Encoded id of the user', required: true
    end

    def_param_group :doc_forgot_password do
      api :GET, '/v1/users/forgot_password', 'Send email to reset password'
      param :email, String, desc: 'Email of the user', required: true
    end

    def_param_group :doc_reset_password do
      api :PATCH, '/v1/users/reset_password', 'Reset password'
      param :password, String, desc: 'Password to be set', required: true
      param :password_confirmation, String, desc: 'Confirmation of password', required: true
      param :reset_password_token, String, desc: 'Reset password token', required: true
      param :role, String, desc: 'Role to login as', required: true
    end
  end
end
