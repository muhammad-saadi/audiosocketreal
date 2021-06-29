ActiveAdmin.register CollaboratorProfile do
  menu false

  actions :edit, :update

  controller do
    def index
      redirect_to admin_artists_collaborators_path
    end

    def show
      redirect_to admin_artists_collaborator_path(CollaboratorProfile.find(params[:id]).artists_collaborator)
    end
  end

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

  form do |f|
    f.inputs do
      f.label "Artist Collaborator ##{f.object.artists_collaborator.id}"
      f.input :pro
      f.input :ipi
      f.input :different_registered_name
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
