ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id, :artwork

  includes :user

  filter :name_or_tracks_title_cont, as: :string, label: 'Search'
  filter :name_cont, as: :string, label: 'Name'
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :tracks_title_cont, as: :string, label: 'Track title'
  filter :created_at

  action_item 'Filters', only: :index do
    link_to('Filters', '/', id: 'sidebar_toggle')
  end

  member_action :download_zip, method: :get do
    album = Album.find(params[:id])
    zipline(album.tracks.to_zip, "#{album.name}.zip")
  end

  index do
    selectable_column
    id_column
    column :name
    column :release_date
    column 'Artist Name', :user
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    column :actions do |album|
      span link_to t('active_admin.view'), admin_album_path(album), class: 'small button'
      span link_to t('active_admin.edit'), edit_admin_album_path(album), class: 'small button'
      span link_to t('active_admin.delete'), admin_album_path(album), class: 'small button', method: :delete
      span link_to 'Download', download_zip_admin_album_path(album), class: 'small button'
    end
  end

  show do
    attributes_table do
      row :name
      row :release_date, &:release_date
      row :artwork do
        if album.artwork.attached?
          span image_tag(album.artwork, width: 100, height: 100)
          br
          span link_to 'Download', rails_blob_path(album.artwork, disposition: "attachment"), class: 'small button'
        end
      end
      row('Artist Name'){ |r| r.user }
    end

    panel 'Tracks' do
      panel('', class: 'align-right') do
        link_to 'Add new Track', new_admin_track_path(track: { album_id: album.id }), class: 'medium button'
      end

      table_for album.tracks do
        if album.tracks.blank?
          column 'No Records Found'
        else
          column :id
          column :title
          column :status
          column :actions do |track|
            link_to 'view', admin_track_path(track), class: 'small button'
          end
        end
      end
    end

    panel 'Notes' do
      table_for album.notes do
        if album.notes.blank?
          column 'No Records Found'
        else
          column :id
          column :status
          column :actions do |note|
            link_to 'view', admin_note_path(note), class: 'small button'
          end
        end
      end
    end

    active_admin_comments
  end

  csv do
    column :id
    column :name
    column :release_date, &:formatted_release_date
    column (:user) { |album| album.user.full_name }
    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :release_date, as: :date_picker
      f.input :artwork, as: :file
      f.input :user, as: :searchable_select , collection: User.artist, label: 'Artist', include_blank: 'Select an Artist'
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_albums_path)
    end
  end
end
