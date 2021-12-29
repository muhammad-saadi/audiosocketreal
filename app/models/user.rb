# frozen_string_literal: true

class User < ApplicationRecord
  include Roles
  include Pagination
  include Followable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :artist_profile, dependent: :destroy

  has_many :auditions, foreign_key: 'assignee_id', dependent: :destroy
  has_many :users_agreements, dependent: :destroy
  has_many :agreements, through: :users_agreements
  has_many :albums, dependent: :destroy
  has_many :publisher_users, dependent: :destroy
  has_many :publishers, through: :publisher_users, validate: false
  has_many :tracks, through: :albums
  has_many :artists_details, foreign_key: 'collaborator_id', class_name: 'ArtistsCollaborator', dependent: :destroy
  has_many :collaborators_details, foreign_key: 'artist_id', class_name: 'ArtistsCollaborator', dependent: :destroy
  has_many :artists, through: :artists_details
  has_many :collaborators, through: :collaborators_details
  has_many :notes, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password, confirmation: true

  attr_accessor :skip_password_validation

  before_save :validate_manager
  after_create :create_default_publisher, if: :artist?
  after_create :default_artist_collaborator, if: :artist?

  # TODO : We do not need this activated currently.
  # after_update :mail_accountant
  # after_touch :mail_accountant

  scope :ordered, -> { order(created_at: :desc) }

  W9_FORM = 'w9'
  W8BEN_FORM = 'w8ben'

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
    super(id.to_i)
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def encoded_id
    JsonWebToken.encode({ id: id })
  end

  def assign_agreements(role, artist = artist_profile)
    new_agreements = artist.exclusive? && Agreement.exclusives || Agreement.non_exclusives
    users_agreements.create(new_agreements.ids.map { |id| { agreement_id: id, role: role } })
  end

  def initialize_collaborator(params)
    collaborator = User.find_or_initialize_by(email: params[:email])
    collaborator.assign_attributes(split_name(params[:name])) if collaborator.new_record?
    collaborator.skip_password_validation = true
    collaborator.add_collaborator_role
    raise ExceptionHandler::ValidationError.new(collaborator.errors.to_h, 'Error inviting collaborator.') unless collaborator.save

    collaborator.assign_agreements('collaborator', artist_profile)
    collaborator
  end

  def collaborator_invite_init(collaborator)
    artist_collaborator = ArtistsCollaborator.find_or_initialize_by(artist_id: id, collaborator_id: collaborator.id)
    raise ExceptionHandler::InvalidAccess, 'Invitation already sent to this email.' if artist_collaborator.persisted?

    artist_collaborator
  end

  def invite_collaborator(params)
    collaborator = initialize_collaborator(params)
    artist_collaborator = collaborator_invite_init(collaborator)
    unless artist_collaborator.update(access: params[:access], status: 'pending', collaborator_profile_attributes: params[:collaborator_profile_attributes])
      raise ExceptionHandler::ValidationError.new(artist_collaborator.errors.to_h, 'Error inviting collaborator.')
    end

    CollaboratorMailer.invitation_mail(id, artist_collaborator.id, collaborator.email).deliver_later
  end

  def agreements_accepted?(role)
    users_agreements&.accepted?(role) || false
  end

  def roles_string
    roles.map(&:titleize)
  end

  def form_number
    return W9_FORM if artist_profile&.contact_information&.country == 'United States'

    W8BEN_FORM
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

  def split_name(name)
    { first_name: name&.split(/ /, 2)&.first, last_name: name&.split(/ /, 2)&.second }
  end

  def mail_accountant
    return unless artist?

    changes = previous_changes.merge(artist_profile&.previous_changes.to_h, artist_profile&.attachment_changes.to_h, artist_profile&.contact_information&.previous_changes.to_h,
                                     artist_profile&.payment_information&.previous_changes.to_h, artist_profile&.tax_information&.previous_changes.to_h)
    return if created_at_previously_was.blank?

    keys = changes.keys - %w[updated_at created_at id update_count]
    ArtistMailer.alert_accountant(id, keys).deliver_later unless keys.blank?
  end

  def password_required?
    return false if skip_password_validation

    super
  end

  def create_default_publisher
    self.publisher_users.create(publisher: Publisher.find_by(name: DEFAULT_PUBLISHER_NAME), pro: DEFAULT_PUBLISHER_PRO, ipi: DEFAULT_PUBLISHER_IPI)
  end

  def default_artist_collaborator
    ArtistsCollaborator.create!(artist_id: self.id, status: :accepted, collaborator_id: self.id, access: :write)
  end
end
