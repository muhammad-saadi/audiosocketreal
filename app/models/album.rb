class Album < ApplicationRecord
  belongs_to :user

  has_many :tracks, dependent: :destroy

  has_one_attached :artwork

  validates :name, presence: true
  validates :artwork, blob: { content_type: :image }

  def self.pagination(params)
    return all if params[:pagination] == 'false'

    page(params[:page].presence || 1).per(params[:per_page].presence || PER_PAGE)
  end
end
