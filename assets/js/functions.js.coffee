"use strict"

###
MBP - Mobile boilerplate helper functions
###
((document) ->
  window.MBP = window.MBP or {}
  
  # If we split this up into two functions we can reuse
  # this function if we aren't doing full page reloads.
  
  # If we cache this we don't need to re-calibrate everytime we call
  # the hide url bar
  MBP.BODY_SCROLL_TOP = false
  
  # So we don't redefine this function everytime we
  # we call hideUrlBar
  MBP.getScrollTop = ->
    win = window
    doc = document
    win.pageYOffset or doc.compatMode is "CSS1Compat" and doc.documentElement.scrollTop or doc.body.scrollTop or 0

  
  # It should be up to the mobile
  MBP.hideUrlBar = ->
    win = window
    
    # if there is a hash, or MBP.BODY_SCROLL_TOP hasn't been set yet, wait till that happens
    win.scrollTo 0, (if MBP.BODY_SCROLL_TOP is 1 then 0 else 1)  if not location.hash and MBP.BODY_SCROLL_TOP isnt false

  MBP.hideUrlBarOnLoad = ->
    win = window
    doc = win.document
    bodycheck = undefined
    
    # If there's a hash, or addEventListener is undefined, stop here
    if not location.hash and win.addEventListener
      
      # scroll to 1
      window.scrollTo 0, 1
      MBP.BODY_SCROLL_TOP = 1
      
      # reset to 0 on bodyready, if needed
      bodycheck = setInterval(->
        if doc.body
          clearInterval bodycheck
          MBP.BODY_SCROLL_TOP = MBP.getScrollTop()
          MBP.hideUrlBar()
      , 15)
      win.addEventListener "load", ->
        setTimeout (->
          
          # at load, if user hasn't scrolled more than 20 or so...
          
          # reset to hide addr bar at onload
          MBP.hideUrlBar()  if MBP.getScrollTop() < 20
        ), 0


  MBP.hideUrlBarOnLoad()
) document