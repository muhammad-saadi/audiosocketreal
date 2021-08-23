ActiveAdmin.register UsersAgreement do
  menu false

  controller do
    def index
      redirect_to admin_artists_path
    end

    def show
      @agreement = UsersAgreement.find(params[:id])
      redirect_to [:admin, @agreement.role, { id: @agreement.user.id }]
    end
  end

  permit_params :user_id, :agreement_id, :status, :status_updated_at, :role

  includes :agreement, :user

  filter :agreement, as: :select, collection: -> { agreements_list }
  filter :status
  filter :role, as: :select, collection: -> { users_agreement_roles_list }
  filter :created_at

  index do
    selectable_column
    id_column
    column :user do |agreement|
      link_to agreement.user.email, [:admin, agreement.role, { id: agreement.user.id }]
    end
    column :agreement
    column :status do |agreement|
      agreement.status&.titleize
    end

    column :status_updated_at
    column :role do |agreement|
      agreement.role&.titleize
    end

    column :created_at, &:formatted_created_at
    column :updated_at, &:formatted_updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :user, collection: [f.object.user], include_blank: false
      f.input :agreement, as: :select, collection: agreements_list, include_blank: false
      f.input :status, as: :select, collection: users_agreements_status_list, include_blank: false
      f.input :role, as: :select, collection: [[f.object.role&.titleize, f.object.role]], include_blank: false
    end

    f.actions do
      f.action :submit
      f.cancel_link({ action: 'show' })
    end
  end
end
