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

  $('#permission_user_search').autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: '/manage/permissions/users/search?term='+$('#permission_user_search').val(),
        dataType: "json",
        data: request.term,
        success: function(data) {
         response($.map(data, function(item){
           var user_name = [item.last_name, item.first_name].join(' ');

           var item_string = user_name.length > 0  ? user_name : '';

           (user_name.length > 1 && item.email.length > 0) ? item_string += ', ' : '';

           item.email.length > 0 ? item_string += '<'+item.email+'>' : '';

           return {
             uid:        item.id,
             label:      item_string,
             value:      item_string,
             first_name: item.first_name,
             last_name:  item.last_name,
             email:      item.email
           }
         }));
        }
      })
    },
    minLength: 2,
    select: function(event, ui){
      $('#permission_user_uid').val(ui.item.uid);
      $('#permission_user_first_name').val(ui.item.first_name);
      $('#permission_user_last_name').val(ui.item.last_name);
      $('#permission_user_email').val(ui.item.email);
    }
  });
});
