//= require esp_permissions/jquery.noisy.min.js

$(function(){
  $('.container').noisy({
    'intensity' : 1,
    'size' : 200,
    'opacity' : 0.08,
    'fallback' : '',
    'monochrome' : false
  });

  $('.show_permissions').click(function(){
    var $this = $(this);
    var this_permission_list = $this.parent().next('.permission_list');

    $('.permission_list').not(this_permission_list).slideUp();
    $('.show_permissions').not($this).removeClass('active').html('&darr;&nbsp;Показать права доступа');

    this_permission_list.slideToggle('slow',function(){
      if ($(this).is(':visible')) {
        $this.addClass('active').html('&uarr;&nbsp;Скрыть права доступа');
      }else{
        $this.removeClass('active').html('&darr;&nbsp;Показать права доступа');
      };
    });

    return false;
  });
});
