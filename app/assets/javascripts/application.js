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
    var url = $elm.data('typeahead-url');
    var displayField = $elm.data('typeahead-display-field');

    if (!url) return;

    $elm.typeahead({
      onSelect: function(item) {
        $elm.data('title', item.text );
        $elm.closest('.form-group').removeClass('has-error')
          .find('.help-block .text-danger').remove()
        $elm.closest('.form-group').find('.help-block').hide();
      },
      ajax: {
        url: url,
        timeout: 500,
        displayField: displayField || 'name',
        triggerLength: 1,
        method: "get",
        preProcess: function (data) {
          return data;
        }
      }
    }).on('blur', function(){
      if ( $(this).val() === $elm.data('title') ) {
        $(this).closest('.form-group').removeClass('has-error')
          .find('label .text-danger').remove();
      } else {
        if (! $(this).closest('.form-group').hasClass('has-error')) {
          $(this).closest('.form-group').addClass('has-error')
            .find('.help-block').show().append('&nbsp;&nbsp;<span class="text-danger">자동 완성된 이슈를 선택해야 합니다.</span>');
        }
        $(this).focus();
      }
    });
  });

  // masonry
  var $container = $('.masonry-container');
  $container.masonry({
    itemSelector: '.post'
  });

  // tags
  $('input[data-toggle="tag-input-helper"]').selectize({
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
