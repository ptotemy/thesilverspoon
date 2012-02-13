  def update
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
if @<%= instance_name %>.update_attributes(params[:<%= instance_name %>])
 if !params[:integrated_view].nil?
    redirect_to <%= item_resource.pluralize %>_integrated_view_path, :notice => "Successfully created <%= class_name.underscore.humanize.downcase %>."
else
      redirect_to <%= items_url %>, :notice => "Successfully created <%= class_name.underscore.humanize.downcase %>."
end


    else
      render :edit
    end
  end
