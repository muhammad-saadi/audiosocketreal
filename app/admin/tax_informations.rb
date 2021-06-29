ActiveAdmin.register TaxInformation do
  menu false

  actions :all, except: [:destroy]

  controller do
    def index
      redirect_to admin_artists_path
    end

    def show
      redirect_to admin_artist_path(TaxInformation.find(params[:id]).artist_profile.user)
    end
  end

  includes :artist_profile

  permit_params :ssn, :artist_profile_id

  filter :artist_profile, as: :searchable_select
  filter :ssn

  form do |f|
    f.inputs do
      f.input :ssn
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link(admin_artist_profile_path(f.object.artist_profile_id))
    end
  end
end
