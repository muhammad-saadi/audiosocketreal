ActiveAdmin.register UsersAgreement do
  config.remove_action_item(:new)

  permit_params :user_id, :agreement_id, :status, :status_updated_at, :role

  includes :agreement, :user

  filter :agreement, as: :select, collection: Agreement.all.map { |agreement| ["Agreement ##{agreement.id}", agreement.id] }
  filter :status
  filter :role

  index do
    selectable_column
    id_column
    column :user do |agreement|
      link_to agreement.user.email, case agreement.role
                              when 'collaborator'
                                admin_collaborator_path(agreement.user)
                              when 'artist'
                                admin_artist_path(agreement.user)
                              end
    end
    column :agreement
    column :status do |agreement|
      agreement.status&.titleize
    end

    column :status_updated_at
    column :role do |agreement|
      agreement.role&.titleize
    end

    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :user do |agreement|
        link_to agreement.user.email, case agreement.role
                              when 'collaborator'
                                admin_collaborator_path(agreement.user)
                              when 'artist'
                                admin_artist_path(agreement.user)
                              end
      end
      row :agreement
      row :status do |agreement|
        agreement.status&.titleize
      end

      row :status_updated_at
      row :role do |agreement|
        agreement.role&.titleize
      end

      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :user, collection: [f.object.user], include_blank: false
      f.input :agreement, as: :select, collection: Agreement.all.map { |agreement| ["Agreement ##{agreement.id}", agreement.id] }, include_blank: false
      f.input :status, as: :select, collection: UsersAgreement.statuses.keys.map { |key| [key.titleize, key] }, include_blank: false
      f.input :role, as: :select, collection: [[f.object.role&.titleize, f.object.role]], include_blank: false
    end
    f.actions
  end
end
