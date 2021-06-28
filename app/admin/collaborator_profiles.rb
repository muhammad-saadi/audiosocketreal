ActiveAdmin.register CollaboratorProfile do
  actions :all, except: [:destroy, :new, :create]

  includes :artists_collaborator

  permit_params :pro, :ipi, :different_registered_name

  filter :artists_collaborator, as: :select, collection: -> { artists_collaborators_list }
  filter :created_at

  index do
    selectable_column
    id_column
    column :artists_collaborator
    column :pro
    column :ipi
    column :different_registered_name
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :artists_collaborator
      row :pro
      row :ipi
      row :different_registered_name
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.label "Artist Collaborator ##{f.object.artists_collaborator.id}"
      f.input :pro
      f.input :ipi
      f.input :different_registered_name
    end
    f.actions
  end
end
