class Api::V1::ArtistsSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :agreements

  def agreements
    object.users_agreements && current_user.users_agreements.joins(:agreement).where('agreement.agreement_type':
      object.artist_profile.exclusive?? Agreement::TYPES[:exclusive] : Agreement::TYPES[:non_exclusive]).pluck(:status).all?('accepted')
  end
end
