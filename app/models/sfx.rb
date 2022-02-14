class Sfx < ApplicationRecord
  include Pagination
  include Favoritable
  include Listable

  has_many :media_filters, as: :filterable, dependent: :destroy
  has_many :filters, through: :media_filters

  has_one_attached :file

  validates :title, :file, :keyword, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }

  after_save :set_duration

  SFX_EAGER_LOAD_COLS = { filters: [:parent_filter, :sfxes, sub_filters: [:sfxes, sub_filters: [:sfxes, :sub_filters]]], file_attachment: :blob }.freeze

  scope :order_by, ->(attr, direction) { order("#{attr} #{direction}") }

  def filename(index = '')
    name = file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end

  def self.to_zip
    all.each_with_index.inject([]) do |zip_list, (sfx, index)|
      next zip_list unless sfx.file.attached?

      file_name = zip_list.pluck(1).include?(sfx.filename) ? sfx.filename(" (#{index})") : sfx.filename
      zip_list << [sfx.file, file_name]
    end
  end

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  ransacker :char_id do
    Arel.sql("to_char(\"sfxes\".\"id\", '99999')")
  end

  def self.search(arguments = {})
    scope = self
    scope = scope.with_ids(arguments[:ids]) if arguments[:ids].present?
    scope = scope.filter_search(arguments[:filters]) if arguments[:filters].present?
    scope = scope.db_search(arguments[:query]) if arguments[:query].present?
    scope = scope.includes(SFX_EAGER_LOAD_COLS)
    scope = scope.order_by(arguments[:order_by], arguments[:direction].presence || 'ASC') if arguments[:order_by].present?

    scope
  end

  def self.with_ids(ids)
    self.ransack('id_in': ids).result(distinct: true)
  end

  def self.db_search(query)
    query_words = query.split(' ')
    query_words << query
    query_array = query_words.flatten.uniq
    query_array = query_array.map{ |obj| "%#{obj}%" }

    self.ransack("char_id_or_title_or_keyword_or_filters_name_matches_any": query_array).result(distinct: true)
  end

  def self.filter_search(filters)
    filter_words = filters.split(',')
    filter_array = filter_words.flatten.uniq

    self.ransack("filters_name_matches_any": filter_array).result(distinct: true)
  end

  def set_duration
    return if self.attachment_changes.empty?

    filepath = self.attachment_changes['file'].attachable.path
    self.update_columns(duration: FFMPEG::Movie.new(filepath).duration&.round(2))
  end

  def filter_count
    self.filters.size
  end
end
