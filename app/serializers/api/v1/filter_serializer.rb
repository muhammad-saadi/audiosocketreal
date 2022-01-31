class Api::V1::FilterSerializer < BaseSerializer
  attributes :id, :name, :sub_filters, :media_count

  def sub_filters
    object.sub_filters&.map { |filter| Api::V1::FilterSerializer.new(filter) }
  end

  def media_count
    object.send(object.kind.downcase.pluralize).size
  end
end
