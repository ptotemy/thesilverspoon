class <%= class_name %> < ActiveRecord::Base

  <%= " set_table_name :#{table_name}\n" if table_name -%>

  # ---------------
  # Accessible Attributes
  # ---------------
  # Only accessible attributes can be created or modified. In case, you add more attributes through a later migration,
  # remember to add the attribute to the attr_accessible list. Otherwise, many an hour is lost in figuring out why data is not
  # getting captured through forms...

   attr_accessible <%= model_attributes.map { |a| ":#{a.name}" }.join(", ") %>

  # ---------------
  # Associations
  # ---------------
  # Uncomment, copy and add you associations here...
  # belongs_to                :parent
  # has_many                  :children, :dependent=>:destroy
  # has_and_belongs_to_many   :friends
  # has_one                  :life


  # ---------------
  # Validations
  # ---------------
  # These are the standard validations that you might need to use with the models. Please uncomment as required...

  <% model_attributes.each do |attribute|%>
  # validates_presence_of :<%="#{attribute.name}" %>
  <% if attribute.type==:integer -%>
# validates_numericality_of :<%="#{attribute.name}"%>
  <% elsif attribute.type==:string -%>
# validates_length_of :<%= "#{attribute.name}" %> ,:maximum=>255
  <% end -%>
  <% end -%>

  # ---------------
  # Schema Information
  # ---------------
  # Just so that you do not have to open up the migration file to check this everytime...

    <% model_attributes.each do |attribute| %>
  # <%= attribute.name %>:<%=attribute.type %>
    <% end %>

  # ---------------
  # Scope
  # ---------------
  # Consider using a model scope if you find yourself having to use 'order' too frequently in your finds

  # default_scope order('created_at DESC')

end
