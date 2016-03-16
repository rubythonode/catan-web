//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-typeahead
//= require masonry.pkgd
//= require bootstrap.offcanvas
//= require selectize
//= require redactor
//= require redactor2_rails/config
//= require jquery.oembed
//= require jssocials
//= require owl.carousel
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//= require bootstrap-tabdrop

$(function(){
  // blank
  $.is_blank = function (obj) {
    if (!obj || $.trim(obj) === "") return true;
    if (obj.length && obj.length > 0) return false;

    for (var prop in obj) if (obj[prop]) return false;
    return true;
  };

  // unobtrusive_flash
  UnobtrusiveFlash.flashOptions['timeout'] = 5000;

  // typeahead
  $('[data-provider="parti-issue-typeahead"]').each(function(i, elm) {
    var $elm = $(elm);
    var url = $elm.data('typeahead-url');
    var displayField = $elm.data('typeahead-display-field');

    if (!url) return;

    $elm.bind('keydown', function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
        }
    });
    var clear_error = function() {
      $elm.closest('.form-group').removeClass('has-error')
          .find('.help-block.typeahead-warning').empty().hide();
    }
    $elm.typeahead({
      onSelect: function(item) {
        $elm.data('title', item.text );
        clear_error();
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
        clear_error();
      } else {
        $.ajax({
          url: "/issues/exist.json",
          type: "get",
          data:{ title: $(this).val() },
          success: function(data) {
            if($.parseJSON(data)) {
              clear_error();
            } else {
              $elm.closest('.form-group').addClass('has-error')
                  .find('.help-block.typeahead-warning').show().append('<span class="text-danger">자동 완성된 이슈나 추천하는 이슈를 선택해야 합니다.</span>');
            }
          },
          error: function(xhr) {
            //ignore server error
            clear_error();
          }
        });
      }
    });
  });

  //masonry
  var $container = $('.masonry-container');
  $container.masonry({
    itemSelector: '.card'
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

  // $("a.embed").oembed();
  $("a.embed").oembed(null, { 'maxWidth': '100%', 'maxHeight': '100%' });

  // toggle
  $('[data-toggle="parti-toggle"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $target = $($elm.data('toggle-target'));

    $target.toggle();
  });

  //switch
  $('[data-toggle="parti-switch"]').each(function(i, elm) {
    var $elm = $(elm);
    var $target = $($elm.data('switch-target'));
    $target.hide();
  });
  $('[data-toggle="parti-switch"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $target = $($elm.data('switch-target'));

    $elm.hide();
    $target.show();
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
    shares: ["twitter", "facebook"]
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

  // modal
  $('.modal').on('show.bs.modal', function (e) {
    var button = $(e.relatedTarget);
    var message = button.data('message')

    var modal = $(this)
    if(message) {
      modal.find('.modal-message').html(message);
    }
  });

  // carousel
  $('[data-ride="parti-carousel"]').each(function(i, elm) {
    var $elm = $(elm);
    var margin = $elm.data('carousel-magin');
    if(!margin) {
      margin = 0;
    }
    $elm.owlCarousel({
      loop:true,
      nav:true,
      margin: margin,
      navText: [
        '<i class="fa fa-arrow-left">',
        '<i class="fa fa-arrow-right">',
      ],
      dots: false,
      responsive:{
          0:{
              items:1
          },
          1000:{
              items:2
          }
      }
    });
    var next = $elm.data('carousel-next');
    var prev = $elm.data('carousel-prev');
    $(next).click(function(){
      $elm.trigger('owl.next');
    });
    $(prev).click(function(){
      $elm.trigger('owl.prev');
    });
  });

  // dropdown preselect
  $('[data-ride="preselect"]').each(function(i, elm) {
    var $elm = $(elm);
    $elm.find(".dropdown-menu li a").click(function(){
      var selText = $(this).html() + '<span class="caret pull-right" style="margin-top: 7px;"></span>';
      $(this).parents('.dropdown').find('.dropdown-toggle').html(selText);
    });
    $elm.find('.dropdown-menu li.active a').trigger('click');
  });

  // overlay
  $('[data-toggle="parti-login-overlay"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);

    var after_login = $elm.attr('data-after-login');
    var $input = $('#login-overlay form input[name=after_login]');
    $input.val(after_login);

    var label_content = $elm.attr('data-label');
    var $label = $('#login-overlay .login-overlay__label');
    $label.html(label_content);

    $("#login-overlay").fadeToggle();
  });
  $('[data-dismiss="parti-login-overlay"]').on('click', function(e) {
    e.preventDefault();
    $("#login-overlay").fadeOut(400, function() {
      var $input = $('#login-overlay form input[name=after_login]');
      $input.val('');
      var $label = $('#login-overlay .login-overlay__label');
      $label.html('');
    });
  });

  // form submit link
  $('[data-action="parti-form-submit"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $form = $($elm.data('form-target'));
    var url = $elm.data('form-url');
    $form.attr('action', url);
    $form.submit();
  });

  // form set value
  $('[data-action="parti-form-set-vaule"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $control = $($elm.data('form-control'));
    var value = $elm.data('form-vaule');
    $control.val(value);
    $control.trigger("blur");
  });

  $('[data-action="parti-search-link"]').on('blur', function(e) {
    var $elm = $(e.currentTarget);
    var $group = $elm.closest('.form-group');
    var $result_block = $group.find('.help-block__search-link');
    if($elm.val() == '') {
      $result_block.empty();
    } else {
      $.ajax({
        url: "/articles/matched_link",
        type: "get",
        data:{ link: $elm.val() },
        success: function(data) {
          $result_block.html(data);
        },
        error: function(xhr) {
          //ignore server error
          $result_block.empty();
        }
      });
    }

  });
});


