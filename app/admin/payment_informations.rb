ActiveAdmin.register PaymentInformation do
  menu false

  actions :all, except: [:destroy]

  controller do
    def index
      redirect_to admin_artists_path
    end

    def show
      redirect_to admin_artist_path(PaymentInformation.find(params[:id]).artist_profile.user)
    end
  end

  includes :artist_profile

  filter :payee_name
  filter :bank_name
  filter :artist_profile, as: :searchable_select

  permit_params :payee_name, :bank_name, :routing, :account_number, :paypal_email, :artist_profile_id

  form do |f|
    f.inputs do
      f.input :payee_name
      f.input :bank_name
      f.input :routing
      f.input :account_number
      f.input :paypal_email
      f.input :artist_profile, as: :select, collection: [f.object.artist_profile], include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
