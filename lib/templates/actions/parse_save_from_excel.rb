def parse_save_from_excel
    test_file = params[:excel_file]
    file = FileUploader.new
    if file.store!(test_file)
      book = Spreadsheet.open "#{file.store_path}"
      sheet1 = book.worksheet 0

       @<%= instance_name %>  = []
      @errors = Hash.new
      @counter = 0

      sheet1.each 1 do |row|
        @counter+=1
        <%- final_query="find_by_" -%>
        <%- final_arguments="" -%>
        <%- a="_and_" -%>
        p = <%= class_name %>.new
        <%- model_attributes.each_with_index do |attribute,index| -%>
        <%- final_query=final_query+ attribute.name %>
        <%- final_arguments=final_arguments+"p."+attribute.name -%>
        <%-if index < model_attributes.length-1 -%>
        <%- final_query=final_query+ a %>
        <%- final_arguments=final_arguments+ "," %>
        <%- end -%>
         p.<%=attribute.name %> = row[<%=index%>]
        <%- end -%>
        unless <%= class_name %>.<%=final_query%>(<%= final_arguments %>)
          if p.valid?
            p.save
          else
            @errors["#{@counter+1}"] = p.errors
          end
        end
      end
      file.remove!
      if @errors.empty?
        redirect_to <%= item_path %>, notice: 'All Dummy data were successfully uploaded.'
      else
        redirect_to <%= item_path %>, notice: 'There were some errors in your upload'
      end

    else
      redirect_to <%= item_path %>, notice: 'Dummy datum could not be successfully uploaded.'
    end
  end