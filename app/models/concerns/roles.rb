module Roles
  extend ActiveSupport::Concern

  module ClassMethods
    def enum_roles(roles_hash = nil)
      raise StandardError, 'Roles must initiate on hash.' unless roles_hash.is_a? Hash

      begin
        key = roles_hash.keys.first.to_s
        unless columns_hash[key].array? && columns_hash[key].type == :text
          raise StandardError, 'Roles must be defined on an array of text.'
        end
      rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
        # Ignored
      end

      roles = roles_hash[key.to_sym]

      roles.keys.each do |role|
        define_singleton_method role do
          where("'#{roles[role]}' = ANY(users.#{key})")
        end

        define_singleton_method "not_#{role}" do
          where.not("'#{roles[role]}' = ANY(users.#{key})")
        end

        define_singleton_method "build_#{role}" do
          new(roles: [roles[role]])
        end

        define_method "#{role}?" do
          public_send(key).include?(roles[role])
        end

        define_method "not_#{role}?" do
          !public_send("#{role}?")
        end

        define_method "#{role}!" do
          set_property(key, [roles[role]])
          save
        end

        define_method "destroy_#{role}_role" do
          public_send(key).delete(roles[role])
          save
        end

        define_method "add_#{role}_role" do
          return true if public_send(key).include?(roles[role])

          add_property(key, roles[role])
          save
        end

        define_method "make_#{role}_primary" do
          set_property(key, public_send(key).partition { |r| r != roles[role] }.flatten)
          save
        end

        define_method 'has_multiple_roles?' do
          public_send(key).length > 1
        end

        define_method 'set_property' do |column, value|
          public_send("#{column}=", value)
        end

        define_method 'add_property' do |column, value|
          public_send(column) << value
        end

        define_method 'primary_role' do
          public_send(key).last
        end
      end
    end
  end
end
