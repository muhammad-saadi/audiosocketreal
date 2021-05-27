class User < ApplicationRecord
  include Roles
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
  has_many :artist_collaborators, foreign_key: "collaborator_id", class_name: 'ArtistsCollaborator'
  has_many :collaborator_artists, foreign_key: "artist_id", class_name: 'ArtistsCollaborator'
  has_many :artists, through: :artist_collaborators
  has_many :collaborators, through: :collaborator_artists

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password, confirmation: true

  before_save :validate_manager

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

  def assign_agreements
    self.agreements = artist_profile.exclusive? && Agreement.exclusives || Agreement.non_exclusives
  end

  def collaborator_invitation(params)
    if persisted?
      self.add_collaborator_role
      @collaborator = ArtistsCollaborator.find_or_create_by(artist_id: Current.user.id, collaborator_id: id)
    else
      self.assign_attributes(first_name: splited_name(params[:name])[0], last_name: splited_name(params[:name])[1], roles: ['collaborator'])
      self.save(validate: false)
      @collaborator = ArtistsCollaborator.create(artist_id: Current.user.id, collaborator_id: id)
    end

    if @collaborator.update(access: params[:access])
      CollaboratorMailer.invitation_mail(@collaborator.id, email).deliver_later
    else
      raise ExceptionHandler::ValidationError.new(@collaborator.errors.to_h, 'Error inviting collaborator.')
    end
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
    name.split(/ /, 2)
  end
end
