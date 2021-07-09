ActiveAdmin.register Publisher do
  config.sort_order = 'pro'
  config.order_clause = false
  config.remove_action_item(:new)
  permit_params :name, :user_id, :pro, :ipi

  includes :user

  filter :user, as: :searchable_select, collection: User.artist
  filter :name_cont, as: :string, label: 'Name'
  filter :pro_cont, as: :string, label: 'PRO'
  filter :created_at

  controller do
    def scoped_collection
      end_of_association_chain.ordered_by_pro
    end
  end

  index do
    selectable_column
    id_column
    column :user
    column :name
    column :pro
    column :ipi
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :pro
      row :ipi
      row :user
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  csv do
    column :id
    column (:user) { |publisher| publisher.user.full_name }
    column :name
    column :pro
    column :ipi
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
  end

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: [f.object.user], include_blank: false
      f.input :name
      f.input :pro, as: :searchable_select, collection: pro_list, include_blank: 'Select a PRO'
      f.input :ipi
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_artist_path(f.object.user_id))
    end
  end
end
