Event.observe(document, 'dom:loaded', function() {

  var items = $$('#directory-index.clickable li.file');
  items.each(function(e) {
    e.observe('click', function() {
      if(event.element().getAttribute('value') == 'X') return;
      event.stop();
      var target = event.element().up('li').down('a');
      document.fire('file_browser:select', target.getAttribute('href'));
    })
  });

});
