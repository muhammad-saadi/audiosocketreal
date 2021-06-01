module RolesValidator
  extend ActiveSupport::Concern

  included do
    class << self
      def validate_role(roles: [], operator: 'OR', only: [], except: [])
        if only.present?
          before_action only: only do
            validate_user_role(roles, operator)
          end
        elsif except.present?
          before_action except: except do
            validate_user_role(roles, operator)
          end
        else
          before_action do
            validate_user_role(roles, operator)
          end
        end
      end
    end
  end

  private

  def validate_user_role(roles, operator)
    if operator == 'AND'
      raise ExceptionHandler::InvalidAccess, Message.invalid_access unless (roles - current_user.roles).blank?
    else
      raise ExceptionHandler::InvalidAccess, Message.invalid_access unless (roles & current_user.roles).any?
    end
  end
end
