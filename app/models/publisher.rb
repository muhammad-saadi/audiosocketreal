class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks

  validates :name, :pro, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def self.pagination(params)
    return ordered if params[:pagination] == 'false'

    ordered.page(params[:page].presence || 1).per(params[:per_page].presence || PER_PAGE)
  end
end
