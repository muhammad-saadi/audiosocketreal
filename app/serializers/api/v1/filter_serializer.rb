class Api::V1::FilterSerializer < BaseSerializer
  attributes :id, :name, :sub_filters, :track_count

  def sub_filters
    object.sub_filters&.map { |filter| Api::V1::FilterSerializer.new(filter) }
  end

  def track_count
    object.tracks.size
  end
end
