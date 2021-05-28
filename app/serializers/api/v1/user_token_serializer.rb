class Api::V1::UserTokenSerializer < BaseSerializer
  attributes :name, :password, :agreements

  def name
    object.first_name
  end

  def password
    object.encrypted_password.present?
  end

  def agreements
    object.agreements_accepted?
  end
end
