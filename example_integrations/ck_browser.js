/* Put this in your javascripts directory. Then configure CKEditor with
 * the following attributes:
 *
 *   filebrowserBrowseUrl: '/local/uploaded_files/select/ck_browser',
 *   filebrowserUploadUrl: '/local/uploaded_files/drop/ck_browser',
 *
 * (This assumes your storage is named "local")
 */
Event.observe(document, 'dom:loaded', function() {

  Event.observe(document, 'file_browser:select', function(event) {
    params = window.location.search.toQueryParams();
    (window.opener || window.parent).CKEDITOR.tools.callFunction(params['CKEditorFuncNum'], event.memo);
    window.close();
  });

});
