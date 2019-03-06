module KepplerTravel
  module ApplicationHelper

    def files_exist(type, files, input_name)
      class_images = 'product_images_files'
      url = request.protocol + request.host_with_port + '/'
      clase = type == 1 ? class_images : class_files
      html = ''
      unless files.nil?
        unless files.size == 0
          files.size.times do |i|
            if files[i].file.exists?
              html += "<input type='hidden' name='#{input_name}' value='#{i}' data-id='#{i}'  data-href='#{url + files[i].url}'  data-size='#{files[i].size}' data-url='#{files[i].url}' data-path='#{files[i].current_path}' class='#{clase}' data-content='#{files[i].content_type}' data-name='#{files[i].file.filename}'>"
            end
          end
        end
      end
      html.html_safe
    end
  end
end
