ActiveAdmin.register User, as: 'Collaborator' do
  menu false
  config.remove_action_item(:new)
  permit_params :first_name, :last_name

  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :email
  filter :created_at

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
    column :roles do |collaborator|
      collaborator.roles.map(&:titleize)
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :roles do
        collaborator.roles.map(&:titleize)
      end
    end

    panel 'Artists details' do
      table_for collaborator.artists_details do
        if collaborator.artists_details.blank?
          column 'No Records Found'
        else
          column :id
          column :artist do |artists_detail|
            link_to artists_detail.artist.full_name, admin_artist_path(artists_detail.artist)
          end

          column :access do |artists_detail|
            artists_detail.access&.titleize
          end

          column :status do |artists_detail|
            artists_detail.status&.titleize
          end

          column :actions do |artist|
            link_to t('active_admin.view'), admin_artists_collaborator_path(artist), class: 'small button'
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
          column :agreement
          column 'Agreement Type' do |users_agreement|
            users_agreement.agreement.agreement_type&.titleize
          end

          column :status do |users_agreement|
            users_agreement.status&.titleize
          end

          column :actions do |users_agreement|
            link_to t('active_admin.view'), admin_users_agreement_path(users_agreement), class: 'small button'
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
            link_to t('active_admin.view'), admin_track_path(track), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column :email
    column :first_name
    column :last_name
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
    column (:roles) { |collaborator| collaborator.roles.map(&:titleize) }
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
