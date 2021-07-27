ActiveAdmin.register Filter do
  permit_params :name, :parent_filter_id, :max_levels_allowed, :featured

  controller do
    def scoped_collection
      end_of_association_chain.parent_filters
    end

    def show
      @filter = Filter.find(params[:id])
    end

    def destroy
      @filter = Filter.find(params[:id]).destroy
      redirect_to admin_filter_path(@filter.parent_filter)
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :featured
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :name
      row :max_levels_allowed
      row :featured
      row :parent_filter
      row :created_at
      row :updated_at
    end

    if filter.max_levels_allowed.positive?
      panel 'Sub-Filters' do
        panel('', class: 'align-right') do
          link_to 'Add new Sub-Filter', new_admin_filter_path(filter: { parent_filter_id: filter.id }), class: 'medium button'
        end

        table_for filter.sub_filters do
          if filter.sub_filters.blank?
            column 'No Records Found'
          else
            column :id
            column :name
            column :featured
            column :actions do |filter|
              link_to 'view', admin_filter_path(filter), class: 'small button'
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :parent_filter, as: :select, collection: [f.object.parent_filter], include_blank: false
      f.input :name
      f.input :featured
      if f.object.parent_filter.blank?
        f.input :max_levels_allowed
      else
        f.object.max_levels_allowed = f.object.parent_filter.max_levels_allowed - 1
        f.input :max_levels_allowed, as: :hidden
      end
    end

    f.actions do
      f.action :submit
      f.cancel_link(f.object.persisted? ? { action: 'show' } : admin_filter_path(f.object.parent_filter_id))
    end
  end
end
