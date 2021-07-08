ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id, :artwork

  includes :user

  filter :name_cont, as: :string, label: 'Track title'
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :tracks_title_cont, as: :string, label: 'Track title'
  filter :created_at

  show do
    attributes_table do
      row :name
      row :release_date
      row :artwork do
        image_tag(album.artwork, width: 100, height: 100) if album.artwork.attached?
      end
      row :user
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
    column (:release_date) { |object| formatted_date(object.release_date) }
    column (:user) { |album| album.user.full_name }
    column (:created_at) { |object| formatted_datetime(object.created_at.localtime) }
    column (:updated_at) { |object| formatted_datetime(object.updated_at.localtime) }
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
