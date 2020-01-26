$(document).on('turbolinks:load', function() {
  //   $('select').selectize({
  //     allowEmptyOption: true
  //   });
  $('select').selectric();
  $('.product_main_div').on('click', function(e) {
    var title = $(this)
      .find('.pr_title')
      .text();
    var body = $(this)
      .find('.pr_desc')
      .text();
    var tags = $(this)
      .find('.tags_area')
      .html();
    var price = $(this)
      .find('.product_price')
      .text();
    $('.popup_overlay').show();
    $('.popup_body h3').html(title);
    $('.popup_tags').html(tags);
    $('.popup_body p').html(body);
    $('.popup_price').html(price);
    $('.popup_container').fadeIn(500);
  });
  $('.popup_overlay , .close_popup').on('click', function(e) {
    $('.popup_overlay').hide();
    $('.popup_container').fadeOut(500);
  });
});
