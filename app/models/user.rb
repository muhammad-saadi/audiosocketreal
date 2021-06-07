class User < ApplicationRecord
  include Roles
  include Pagination
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :artist_profile, dependent: :destroy

  has_many :auditions, foreign_key: 'assignee_id', dependent: :destroy
  has_many :users_agreements, dependent: :destroy
  has_many :agreements, through: :users_agreements
  has_many :albums, dependent: :destroy
  has_many :publishers, dependent: :destroy
  has_many :artists_details, foreign_key: "collaborator_id", class_name: 'ArtistsCollaborator', dependent: :destroy
  has_many :collaborators_details, foreign_key: "artist_id", class_name: 'ArtistsCollaborator', dependent: :destroy
  has_many :artists, through: :artists_details
  has_many :collaborators, through: :collaborators_details

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password, confirmation: true

  before_save :validate_manager

  scope :ordered, -> { order(created_at: :desc) }

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  ROLES = {
    manager: 'manager',
    artist: 'artist',
    collaborator: 'collaborator'
  }.freeze

  enum_roles roles: ROLES

  def self.find_by_id(id)
    return nil if id == 'null'

    find(id)
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def encoded_id
    JsonWebToken.encode({ id: id })
  end

  def assign_agreements(role, artist = artist_profile)
      new_agreements = artist.exclusive? && Agreement.exclusives || Agreement.non_exclusives
      @user_agreements = self.users_agreements.create(new_agreements.ids.map{ |id| {agreement_id: id, role: role} })
  end

  def invite_collaborator(params)
    collaborator = User.find_or_initialize_by(email: params[:email])
    collaborator.assign_attributes(splited_name(params[:name])) if collaborator.new_record?

    collaborator.add_collaborator_role
    collaborator.save(validate: false)
    collaborator.assign_agreements('collaborator', Current.user.artist_profile)

    artist_collaborator = ArtistsCollaborator.find_or_create_by(artist_id: id, collaborator_id: collaborator.id)
    if artist_collaborator.update(access: params[:access])
      CollaboratorMailer.invitation_mail(Current.user.id, artist_collaborator.id, collaborator.email).deliver_later
    else
      raise ExceptionHandler::ValidationError.new(artist_collaborator.errors.to_h, 'Error inviting collaborator.')
    end
  end

  def agreements_accepted?(role)
    users_agreements && users_agreements.where(role: role).joins(:agreement).where('agreement.agreement_type':
                        [Agreement::TYPES[:exclusive], Agreement::TYPES[:non_exclusive]]).pluck(:status).all?('accepted')
  end

  private

  def validate_manager
    return unless roles_was.include?(ROLES[:manager])
    return if manager?
    return if auditions.blank?

    errors.add(:base, 'Cannot remove manager role as auditions are assigned.')
    self.roles = roles_was
    raise ActiveRecord::Rollback
  end

  def splited_name(name)
    { first_name: name.split(/ /, 2)[0], last_name: name.split(/ /, 2)[1] }
  end
end
