module AccessValidator
  extend ActiveSupport::Concern

  included do
    class << self
      def validate_collaborator_access(access: [], only: [], except: [])
        if only.present?
          before_action only: only do
            validate_access(access)
          end
        elsif except.present?
          before_action except: except do
            validate_access(access)
          end
        else
          before_action do
            validate_access(access)
          end
        end
      end
    end
  end

  private

  def validate_access(access)
    return unless access.present? && current_user.collaborator?

    unless access.include?(current_user.artists_details.find_by(artist_id: params[:artist_id])&.access)
      raise ExceptionHandler::InvalidAccess, Message.invalid_access
    end
  end
end
