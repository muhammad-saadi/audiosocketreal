ActiveAdmin.register Publisher do
  config.remove_action_item(:new)

  permit_params :name, :user_id, :pro, :ipi

  includes :user

  filter :user, as: :searchable_select, collection: User.artist
  filter :name

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

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: [f.object.user], include_blank: false
      f.input :name
      f.input :pro
      f.input :ipi
    end
    f.actions
  end
end
