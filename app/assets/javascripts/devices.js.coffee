# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.edit-link').on 'click', ->
    row = $(this).closest('tr')
    row.find('span.show').hide()
    row.find('span.edit').show()
    row.stop().css("background-color", "#FFFF9C").animate({ backgroundColor: "#FFFFFF"}, 1500);
    false

  $('#add-me-button').on 'click', ->
    $('#add-me-window').show()
    $('#add-me-window input#device_name').focus()

  $('#add-me-window #close-button').on 'click', ->
    $('#add-me-window').hide()
