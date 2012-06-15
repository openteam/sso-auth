$ ->
  return false unless $("table.journal").length
  $("table.journal .changes a ").click ->
    html = $(this).next(".hidden").html()
    $("<div class='changes_detail'></div>").hide().appendTo("body").html(html)
    $("div.changes_detail").dialog
      modal: true
      width: "80%"
      height: "600"
      close: ->
        $(this).remove()
        $(this).parent().remove()
    return false
