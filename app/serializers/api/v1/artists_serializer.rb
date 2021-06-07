class Api::V1::ArtistsSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :agreements, :access

  def agreements
    object.users_agreements && current_user.users_agreements.collaborators.joins(:agreement).where('agreement.agreement_type':
      object.artist_profile.exclusive?? Agreement::TYPES[:exclusive] : Agreement::TYPES[:non_exclusive]).pluck(:status).all?('accepted')
  end

  def access
    current_user.artists_details.find_by(artist_id: object.id).access
  end
end
