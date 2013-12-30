# CKEditor integration
jQuery(document).ready ($)->
  $(document).on 'file_browser:select', (event, url)->
    func = window.location.search.match(/CKEditorFuncNum=([^&]+)/)[1]
    (window.opener || window.parent).CKEDITOR.tools.callFunction func, url
    window.close()
