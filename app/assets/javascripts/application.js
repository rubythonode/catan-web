//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-typeahead
//= require masonry.pkgd
//= require bootstrap.offcanvas
//= require selectize
//= require redactor-rails
//= require jquery.oembed

$(function(){
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

  // masonry
  var $container = $('.masonry-container');
  $container.masonry({
    percentPosition: true,
    columnWidth: '.post',
    itemSelector: '.post',
  });

  // tags
  $('input#article_tag_list').selectize({
    delimiter: ',',
    persist: false,
    create: function(tag_name) {
      return {
        value: tag_name,
        text: tag_name
      }
    }
  });
  $('[data-action="add-tag"]').on('click', function(e) {
    e.preventDefault();
    var tag_name = $(e.currentTarget).data('tag-name');
    var form_control = $(e.currentTarget).data('form-control');
    var $form_control = $(form_control);
    if($form_control) {
      $form_control.each(function(i, elm) {
        elm.selectize.addOption({value: tag_name, text: tag_name});
        elm.selectize.addItem(tag_name);
      });
    }
  });

  $("a.embed").oembed();
});
