class Api::V1::ArtistsSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :agreements, :access, :status

  def agreements
    object.collaborator.users_agreements.collaborators.joins(:agreement).where('agreement.agreement_type':
      object.artist.artist_profile.exclusive?? Agreement::TYPES[:exclusive] : Agreement::TYPES[:non_exclusive]).pluck(:status).all?('accepted')
  end

  def email
    object.artist.email
  end

  def first_name
    object.artist.first_name
  end

  def last_name
    object.artist.last_name
  end
end
