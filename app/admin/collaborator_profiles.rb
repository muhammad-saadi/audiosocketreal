ActiveAdmin.register CollaboratorProfile do
  menu false

  actions :all, except: [:destroy]

  controller do
    def index
      redirect_to admin_artists_collaborators_path
    end

    def show
      redirect_to admin_artists_collaborator_path(CollaboratorProfile.find(params[:id]).artists_collaborator)
    end
  end

  includes :artists_collaborator

  permit_params :pro, :ipi, :different_registered_name, :artists_collaborator_id

  filter :artists_collaborator, as: :select, collection: -> { artists_collaborators_list }
  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

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
      f.input :artists_collaborator, as: :select, collection: [["Artists Collaborator ##{f.object.artists_collaborator_id}", f.object.artists_collaborator.id]], include_blank: false
      f.input :pro, as: :searchable_select, collection: pro_list, include_blank: 'Select a PRO'
      f.input :ipi
      f.input :different_registered_name
    end

    f.actions do
      f.action :submit
      f.cancel_link(admin_artists_collaborator_path(f.object.artists_collaborator_id))
    end
  end
end
