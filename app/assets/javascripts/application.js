//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-typeahead
//= require_tree .

$(document).on('ready', function(e) {
  $('[data-provider="typeahead"]').each(function(i, elm) {
    var $elm = $(elm);
    var $target = $($elm.data('typeahead-target'));
    var url = $elm.data('typeahead-url');
    var displayField = $elm.data('typeahead-display-field');

    if (!url) return;

    $elm.typeahead({
      onSelect: function(item) {
        if ($target.length) $target.val( item.value );
      },
      ajax: {
        url: url,
        timeout: 500,
        displayField: displayField || 'name',
        triggerLength: 1,
        method: "get",
        preProcess: function (data) {
          if( $target.length && data.issues.length <= 0 ) $target.val('');
          return data.issues;
        }
      }
    });
  });
});
