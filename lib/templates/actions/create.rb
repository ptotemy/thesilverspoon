def create
    @<%= instance_name %> = <%= class_name %>.new(params[:<%= instance_name %>])
if @<%= instance_name %>.save
 if !params[:integrated_view].nil?
    redirect_to <%= item_resource.pluralize %>_integrated_view_path, :notice => "Successfully created <%= class_name.underscore.humanize.downcase %>."
else
      redirect_to <%= items_url %>, :notice => "Successfully created <%= class_name.underscore.humanize.downcase %>."
end
    else
      render :new
    end
  end
