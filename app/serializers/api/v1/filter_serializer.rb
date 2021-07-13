class Api::V1::FilterSerializer < BaseSerializer
  attributes :id, :name, :sub_filters

  def sub_filters
    object.sub_filters&.map { |filter| Api::V1::FilterSerializer.new(filter) }
  end
end
