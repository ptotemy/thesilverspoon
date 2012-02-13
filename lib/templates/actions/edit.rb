 def edit
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
if !params[:get].nil?
 render :layout=>false
end
  end
