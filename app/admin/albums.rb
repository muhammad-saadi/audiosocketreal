ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id
  # action_item only: [:show] do
  #    if album.present?
  # end

  show do
    attributes_table do
      row :name
      row :release_date
      row :user
    end

    panel 'Tracks' do
      panel '' do
        link_to 'Add new Track', new_admin_track_path(track: { album_id: album.id })
      end
      table_for album.tracks do
        column :id
        column :title
        column :actions do |track|
          link_to 'view', admin_track_path(track), class: 'small button'
        end
      end
    end

    active_admin_comments
  end
end
