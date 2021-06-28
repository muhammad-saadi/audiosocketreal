ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    hr
    div do
      columns do
        column do
          panel "Total Artists" do
            User.artist.count
          end
        end

        column do
          panel "Total Albums" do
            Album.count
          end
        end

        column do
          panel "Total Track" do
            Track.count
          end
        end
      end
    end
    hr
    br
    br
    div do
      columns do
        column do
          panel "Unclassified Tracks (#{Track.unclassified.count})" do
            link_to 'Go to Tracks', admin_tracks_path(scope: 'unclassified')
          end
        end

        column do
          panel "Pending Notes (#{Note.pending.count})" do
            link_to 'Go to Notes', admin_notes_path(scope: 'pending')
          end
        end
      end
    end
  end
end
