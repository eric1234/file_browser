//= require 'jquery'

jQuery(document).ready ($)->
  items = $ '#directory-index.clickable li.file'
  items.click (event)->
    return if $(event.target).attr('value') == 'X'
    event.preventDefault();
    target = $(this).find 'a'
    target.trigger 'file_browser:select', target.attr('href')
