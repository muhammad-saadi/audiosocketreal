class Api::V1::UserTokenSerializer < ActiveModel::Serializer
  attributes :name, :password, :agreements

  def name
    object.first_name
  end

  def password
    object.encrypted_password.present?
  end

  def agreements
    object.users_agreements.pluck(:status).all?('accepted')
  end
end
