window.App ||= {}

App.init = ->
  #
   
$(document).on "turbolinks:load", ->
  App.init()