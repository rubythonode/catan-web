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
//= require rails-timeago
//= require locales/jquery.timeago.ko
//= require linkfy
//= require linkify-jquery
//= require autoresize
//= require jquery.validate
//= require messages_ko
//= require kakao

$(function(){
  // blank
  $.is_blank = function (obj) {
    if (!obj || $.trim(obj) === "") return true;
    if (obj.length && obj.length > 0) return false;

    for (var prop in obj) if (obj[prop]) return false;
    return true;
  }

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
      // form validation
      $elm.data('rule-extern-value', true);
      $elm.trigger('parti-need-to-validate');
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
    }).on('keydown', function() {
      $elm.data('rule-extern-value', false);
      $elm.trigger('parti-need-to-validate');
    }).on('blur', function(){
      if($(this).data('typeahead').shown) {
        return;
      }
      if ( $(this).val() === $elm.data('title') ) {
        clear_error();
      } else {
        $.ajax({
          url: "/issues/exist.json",
          type: "get",
          data:{ title: $elm.val() },
          success: function(data) {
            if($.parseJSON(data)) {
              clear_error();
            } else {
              $elm.closest('.form-group').addClass('has-error')
                  .find('.help-block.typeahead-warning').show().html('<span class="text-danger">자동 완성된 이슈나 추천하는 이슈를 선택해야 합니다.</span>');
              // form validation
              $elm.data('rule-extern-value', false);
              $elm.trigger('parti-need-to-validate');
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

    var focus_id = $(e.target).data('focus');
    $focus = $(focus_id);
    $focus.focus();
  });

  // share
  Kakao.init('497c9a46f0645fa96fe0d31c607ba74a');
  $('[data-action="parti-share"]').each(function(i, elm){
    var $elm = $(elm);
    var url = $elm.data('share-url');
    var text = $elm.data('share-text');
    var share = $elm.data('share-provider');
    if ($.is_blank(share)) return;
    var image_url = $elm.data('share-image');
    if ($.is_blank(image_url)) image_url = location.protocol + "//" + location.hostname + "/images/parti_seo.png";
    var image_width = $elm.data('share-image-width');
    if ($.is_blank(image_width)) image_width = '300';
    var image_height = $elm.data('share-image-height');
    if ($.is_blank(image_height)) image_height = '155';

    switch(share) {
      case 'kakao-link':
        Kakao.Link.createTalkLinkButton({
          container: elm,
          label: text,
          image: {
            src: image_url,
            width: image_width,
            height: image_height
          },
          webLink: {
            text: '빠띠에서 보기',
            url: url
          }
        });
      break
      case 'kakao-story':
        Kakao.Story.createShareButton({
          container: elm,
          url: url,
          text: text
        });
      break
      default:
        $elm.jsSocials({
          showCount: true,
          showLabel: false,
          shares: [share],
          text: text,
          url: url
        });
    }
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
    if($.is_blank($elm.val())) {
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

  // parti-smart-placeholder
  $('[data-action="parti-smart-placeholder"]').each(function(i, elm) {
    var $elm = $(elm);
    var placeholder = $elm.attr("placeholder");
    var $previous = $($elm.data("previous-form-control"));
    $elm.attr("placeholder", '');
    $previous.on('input', function(e) {
      var val = $(e.currentTarget).val();
      if(!$.is_blank(val)) {
        $elm.attr("placeholder", placeholder);
      } else {
        $elm.attr("placeholder", '');
      }
    });
  });

  // parti-smart-link
  $('[data-action="parti-smart-link"]').each(function(i, elm) {
    var $elm = $(elm);
    var $control = $($elm.data("source-form-control"));
    $control.on('input', function(e) {
      var val = $(e.currentTarget).val();
      var results = linkify.find(val);
      var parsed_url = '';
      $.each(results, function(i, e) {
        if(e.type !== 'url' || /^(http)s?/.test(e.value)){
          parsed_url = e.value;
          return false;
        }
      });
      switch ($elm.get(0).tagName) {
        case 'A':
          if($.is_blank(parsed_url)) {
            $elm.empty();
            $elm.attr('href', '');
          } else {
            $elm.attr('href', parsed_url)
                .oembed(null, { 'embedMethod': 'fill', 'maxWidth': '100%', 'maxHeight': '100%' });
          }
          break;
        case 'INPUT':
          $elm.val(parsed_url);
          break;
      }
    });
  });

  // autoresize toggle
  autosize($('[data-ride="parti-autoresize"]'));

  // form validation
  $.validator.addMethod("extern", function(value, element) {
    return this.optional(element) || $(element).data('rule-extern-value');
  }, "");

  $('[data-action="parti-form-validation"]').each(function(i, elm) {
    var $elm = $(elm);
    $form = $(elm);
    $submit = $($elm.data("submit-form-control"));
    $submit.prop('disabled', true);

    $form.validate({
      errorPlacement: function(error, element) {
        return true;
      },
      invalidHandler: function(event, validator) {
        // 'this' refers to the form
        var errors = validator.numberOfInvalids();
        if (errors) {
          var message = errors == 1
            ? 'You missed 1 field. It has been highlighted'
            : 'You missed ' + errors + ' fields. They have been highlighted';
          $("div.error span").html(message);
          $("div.error").show();
        } else {
          $("div.error").hide();
        }
      }
    });

    $elm.find(':input').on('input', function(e) {
      if($form.valid()) {
        $submit.prop('disabled', false);
      } else {
        $submit.prop('disabled', true);
      }
    });

    $elm.find(':input').on('parti-need-to-validate', function(e) {
      if($form.valid()) {
        $submit.prop('disabled', false);
      } else {
        $submit.prop('disabled', true);
      }
    });
  });
});

