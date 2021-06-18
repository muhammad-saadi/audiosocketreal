ActiveAdmin.register User, as: 'Collaborator' do
  config.remove_action_item(:new)

  permit_params :first_name, :last_name

  controller do
    def scoped_collection
      end_of_association_chain.collaborator
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :roles
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles
    end

    panel 'Artists details' do
      table_for collaborator.artists_details do
        if collaborator.artists_details.blank?
          column 'No Records Found'
        else
          column :id
          column :artist do |artists_detail|
            link_to artists_detail.artist.email, admin_artist_path(artists_detail.artist)
          end
          column :access
          column :status
          column :actions do |artist|
            link_to t('active_admin.view'), '#', class: 'small button'
          end
        end
      end
    end

    panel 'Agreements' do
      table_for collaborator.users_agreements.collaborator do
        if collaborator.users_agreements.collaborator.blank?
          column 'No Records Found'
        else
          column :id
          column 'Agreement Type' do |users_agreement|
            link_to users_agreement.agreement.agreement_type
          end
          column :status
          column :actions do |users_agreement|
            link_to t('active_admin.view'), '#',class: 'small button'
          end
        end
      end
    end

    panel 'Tracks' do
      @tracks = Track.joins(:artists_collaborator).where('artists_collaborator.collaborator': collaborator)
      table_for @tracks do
        if @tracks.blank?
          column 'No Records Found'
        else
          column :id
          column :title
          column :actions do |track|
            link_to t('active_admin.view'), admin_track_path(track),class: 'small button'
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end
end
