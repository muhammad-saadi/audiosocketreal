ActiveAdmin.register Album do
  permit_params :name, :release_date, :user_id

  show do
    attributes_table do
      row :name
      row :release_date
      row :user
    end

    panel 'Tracks' do
      table_for album.tracks do
        column :title
        column :actions do |track|
          link_to "view", admin_track_path(track), class: 'small button'
        end
      end
    end

    active_admin_comments
  end
end
