$ ->
  $(".scroll").click (event) ->
    event.preventDefault()
    $("html,body").animate
      scrollTop: $(@hash).offset().top
    , 500

  AppShowcase = ->
    $el = $(".showapp")
    $device = $el.children(".iphone")
    $screenImg = $device.children("img")
    $slides = $el.find(".slides > img")
    current = 0
    direction = "next"
    next = ->
      return false  if current is $slides.length
      $currentScreen = $device.children("img:first")
      $nextScreen = $slides.eq(current)
      $("<img src=\"" + $nextScreen.attr("src") + "\" class=\"new\" />").appendTo $device
      $currentScreen.addClass("old").delay(800).hide ->
        $(this).remove()

      current++

    setInterval next, 2500
    API = {}
    API.next = next
    API

  app = AppShowcase()
  app.next()
