ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Total Auditions" do
          ul do
            Audition.count
          end
        end
      end

      column do
        panel "Total Users" do
          ul do
            User.count
          end
        end
      end
    end
  end # content
end
