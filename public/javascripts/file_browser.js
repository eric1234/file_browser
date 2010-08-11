Event.observe(document, 'dom:loaded', function() {

  var items = $$('#directory-index li')
  items.each(function(e) {
    e.observe('click', function() {
      items.each(function(i) {i.removeClassName('selected')});
      e.addClassName('selected');
    })
  });

  var trigger = $('select-file-trigger');
  if(trigger)
    trigger.observe('click', function(event) {
      event.stop();
      var selected = items.find(function(e) {return e.hasClassName('selected')});
      if(!selected) {
        alert('No file selected');
        return;
      }
      var target = selected.down('a');
      if(target.innerHTML == 'Download') {
        document.fire('file_browser:select', target.getAttribute('href'));
      } else {
        alert('You must select a file, not a directory');
      }
    });

  var cancel = $('cancel-file-select');
  if(cancel)
    cancel.observe('click', function(event) {
      event.stop();
      document.fire('file_browser:cancel');
    });
});