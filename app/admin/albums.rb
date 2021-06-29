ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id

  includes :user

  filter :name_cont, as: :string, label: 'Track title'
  filter :user, as: :searchable_select, collection: User.artist, label: 'Artist'
  filter :tracks_title_cont, as: :string, label: 'Track title'
  filter :created_at

  show do
    attributes_table do
      row :name
      row :release_date
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

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :release_date, as: :date_picker
      f.input :user, as: :searchable_select , collection: User.artist, label: 'Artist', include_blank: '(Select an Artist)'
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
