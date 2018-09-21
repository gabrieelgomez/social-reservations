function collectImages(id_input, edit_input, name_input){
  var imagesAdd = []
  imagesData  = $('.product_images_files');
  if (imagesData.length > 0) {
    imagesData.each(function() {
      imagesFiles = {
        name: $(this).data('name'),
        size: $(this).data('size'),
        type: $(this).data('content'),
        file: $(this).data('url'),
        url: $(this).data('href'),
        id: $(this).data('id'),
      };
      imagesAdd.push(imagesFiles)
    });
  }
  $(id_input).filer({
    limit: null,
    maxSize: 3,
    extensions: ['jpg', 'png', 'jpeg', 'pdf', 'svg', 'doc', 'docx', 'ppt', 'pptx'],
    changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Drag&Drop files here</h3> <span style="display:inline-block; margin: 15px 0">or</span></div><a class="jFiler-input-choose-btn blue">Browse Files</a></div></div>',
    showThumbs: true,
    theme: "dragdropbox",
    dragDrop: {
        dragEnter: null,
        dragLeave: null,
        drop: null,
        dragContainer: null,
    },
    files: imagesAdd,
    addMore: true,
    allowDuplicates: false,
    clipBoardPaste: true,
    excludeName: null,
    beforeRender: null,
    afterRender: null,
    beforeShow: null,
    beforeSelect: null,
    onSelect: null,
    afterShow: null,
    templates: {
        box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
        item: '<li class="jFiler-item">\
      <div class="jFiler-item-container">\
        <div class="jFiler-item-inner">\
          <div class="jFiler-item-thumb">\
            <div class="jFiler-item-status"></div>\
            <div class="jFiler-item-thumb-overlay">\
              <div class="jFiler-item-info">\
                <div style="display:table-cell;vertical-align: middle;">\
                  <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name}}</b></span>\
                  <span class="jFiler-item-others">{{fi-size2}}</span>\
                </div>\
              </div>\
            </div>\
            {{fi-image}}\
          </div>\
          <div class="jFiler-item-assets jFiler-row">\
            <ul class="list-inline pull-left">\
              <li>{{fi-progressBar}}</li>\
            </ul>\
            <ul class="list-inline pull-right">\
              <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
            </ul>\
          </div>\
        </div>\
      </div>\
    </li>',
        itemAppend: '<li class="jFiler-item">\
      <div class="jFiler-item-container">\
        <div class="jFiler-item-inner">\
          <div class="jFiler-item-thumb">\
            <div class="jFiler-item-status"></div>\
            <div class="jFiler-item-thumb-overlay">\
              <div class="jFiler-item-info">\
                <div style="display:table-cell;vertical-align: middle;">\
                  <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name}}</b></span>\
                  <span class="jFiler-item-others">{{fi-size2}}</span>\
                </div>\
              </div>\
            </div>\
            {{fi-image}}\
          </div>\
          <div class="jFiler-item-assets jFiler-row">\
            <ul class="list-inline pull-left">\
              <li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
            </ul>\
            <ul class="list-inline pull-right">\
              <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
            </ul>\
          </div>\
        </div>\
      </div>\
      </li>',
        progressBar: '<div class="bar"></div>',
        itemAppendToEnd: false,
        canvasImage: true,
        removeConfirmation: true,
        _selectors: {
            list: '.jFiler-items-list',
            item: '.jFiler-item',
            progressBar: '.bar',
            remove: '.jFiler-item-trash-action'
        }
    },
    onRemove: function (itemEl, file, id, listEl, boxEl, newInputEl, inputEl) {
      $(edit_input).append(`<input type='hidden' name=${name_input} class='imagenes_delete' value=${file.id}>`);
    },
    onEmpty: null,
    options: null,
    captions: {
        button: "Choose Files",
        feedback: "Choose files To Upload",
        feedback2: "files were chosen",
        drop: "Drop file here to Upload",
        removeConfirmation: "Are you sure you want to remove this file?",
        errors: {
            filesLimit: "Only {{fi-limit}} files are allowed to be uploaded.",
            filesType: "Only Images are allowed to be uploaded.",
            filesSize: "{{fi-name}} is too large! Please upload file up to {{fi-maxSize}} MB.",
            filesSizeAll: "Files you've choosed are too large! Please upload files up to {{fi-maxSize}} MB."
        }
    }
  });
}
