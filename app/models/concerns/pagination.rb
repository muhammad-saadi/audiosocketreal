module Pagination
  extend ActiveSupport::Concern

  module ClassMethods
    def pagination(params)
      return all if params[:pagination] == 'false'

      page(params[:page].presence || 1).per(params[:per_page].presence || PER_PAGE)
    end
  end
end
