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
//= require owl.carousel
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//= require bootstrap-tabdrop

$(function(){

  // unobtrusive_flash
  UnobtrusiveFlash.flashOptions['timeout'] = 5000;

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
    $elm.owlCarousel({
      loop:true,
      nav:true,
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

  // tabdrop
  $('.nav-pills, .nav-tabs').tabdrop();

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
    var $input = $('#login-overlay form input[name=after_login]');
    $input.val('');
    var $label = $('#login-overlay .login-overlay__label');
    $label.html('');
    $("#login-overlay").fadeOut();
  });

  // form submit link
  $('[data-trigger="parti-form-submit"]').on('click', function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $form = $($elm.data('form-target'));
    var url = $elm.data('form-url');
    $form.attr('action', url);
    $form.submit();
  });
});


