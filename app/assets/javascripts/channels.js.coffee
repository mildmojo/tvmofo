$ ->
  $('#channel-grid li a').on 'mouseup', (e) ->
    e.stopPropagation()
  $('#channel-grid li').on 'mouseup', (e) ->
    window.location = $(this).find('a').attr('href')