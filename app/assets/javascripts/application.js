//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-typeahead
//= require masonry.pkgd
//= require bootstrap.offcanvas
//= require selectize
//= require redactor-rails
//= require jquery.oembed
//= require jssocials

$(function(){

  // typeahead
  $('[data-provider="typeahead"]').each(function(i, elm) {
    var $elm = $(elm);
    var url = $elm.data('typeahead-url');
    var displayField = $elm.data('typeahead-display-field');

    if (!url) return;

    $elm.bind('keydown', function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
        }
    });
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

  //masonry
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

  // toggle

  $('[data-toggle="parti-toggle"]').on('click', function(e) {
    e.preventDefault();
    $self = $(e.currentTarget);
    var $target = $($self.data('toggle-target'));

    $target.toggle();
  });

  // share

  $("#share-twitter").jsSocials({
    showCount: true,
    showLabel: false,
    shares: ["twitter"]
  });

  $("#share-facebook-page").jsSocials({
    showCount: true,
    showLabel: false,
    shares: ["facebook"],
    text: '유쾌한 정치 플랫폼! 빠띠에서 파티하자!',
    url: 'https://www.facebook.com/parti.xyz/'
  });

  $("#share").jsSocials({
    showCount: true,
    showLabel: false,
    shares: ["facebook", "twitter"]
  });

  $('[data-provider="parti-issue-share"]').each(function(i, elm) {
    var $elm = $(elm);
    var url = $elm.data('share-url');
    var text = $elm.data('share-text');
    $elm.jsSocials({
      showCount: true,
      showLabel: false,
      shares: ["facebook", "twitter"],
      text: text,
      url: url
    });
  });

  // post type filter

  $('[data-toggle="parti-post-type-selection"]').on('change', function(e) {
    e.preventDefault();
    $self = $(e.currentTarget);
    var $optionSelected = $("option:selected", e.currentTarget);
    var url = $optionSelected.data('url');
    $(location).attr('href', url);
  });
});
