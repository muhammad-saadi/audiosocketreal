module Api::V1::Docs::SessionsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_create_session do
      api :POST, "/v1/sessions", "Login user and create session"
      param :email, String, desc: 'Email id for login', required: true
      param :password, String, desc: 'Password for login', required: true
      param :remember_me, [true, false, 'true', 'false'], desc: 'If you want to avoid session expiry', allow_blank: true
      param :role, String, desc: 'Role to login as', required: true
    end
  end
end
