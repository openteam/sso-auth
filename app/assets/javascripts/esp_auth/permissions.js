//= require esp_auth/jquery.noisy.min.js

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
        url: '/auth/users/search?term='+$('#permission_user_search').val(),
        dataType: "json",
        data: request.term,
        success: function(data) {
         response($.map(data, function(item){
           var item_label = item.name

           if (item.email.length > 0) {
             item_label += ' <' + item.email + '>'
           }

           return {
             uid:   item.uid,
             label: item_label,
             value: item_label,
             name:  item.name,
             email: item.email
           }
         }));
        }
      })
    },
    minLength: 2,
    select: function(event, ui){
      $('#permission_user_uid').val(ui.item.uid);
      $('#permission_user_name').val(ui.item.name);
      $('#permission_user_email').val(ui.item.email);
    }
  });
});
