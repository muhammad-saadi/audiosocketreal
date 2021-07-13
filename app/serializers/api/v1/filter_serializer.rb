class Api::V1::FilterSerializer < BaseSerializer
  attributes :id, :name, :sub_filters

  def sub_filters
    object.filters&.map { |filter| Api::V1::FilterSerializer.new(filter) }
  end
end
