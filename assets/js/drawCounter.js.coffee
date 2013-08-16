"use strict"
drawCounter = (money, options) ->
  
  # variables and functions private unless attached to API below
  # 'this' refers to global window
  
  #options
  option = (if (typeof options is "undefined") then {} else options)
  option.canvasID = (if (typeof option.canvasID is "undefined") then "counter" else option.canvasID)
  option.ratio = (if (typeof option.ratio is "undefined") then 2 else option.ratio)
  option.currency = (if (typeof option.currency is "undefined") then " kr" else option.currency)
  option.seperator = (if (typeof option.seperator is "undefined") then "." else option.seperator)
  option.balance = (if (typeof option.balance is "undefined") then "Din saldo er" else option.balance)
  option.background = (if (typeof option.background is "undefined") then "#147EFB" else option.background)
  option.color = (if (typeof option.color is "undefined") then "#FFFFFF" else option.color)
  option.border = (if (typeof option.border is "undefined") then "#f9f9f9" else option.border)
  option.borderShadow = (if (typeof option.borderShadow is "undefined") then "#dedede" else option.borderShadow)
  option.fontTxt = (if (typeof option.fontTxt is "undefined") then "Neue Light" else option.fontTxt)
  option.fontAmount = (if (typeof option.fontAmount is "undefined") then "Neue Lighter" else option.fontAmount)
  
  #define circle angle
  circle = {}
  circle.startAngle = 0 * Math.PI / 180
  circle.endAngle = 360 * Math.PI / 180
  
  #amount
  amount = {}
  moneySplit = money.toString().split(".")
  amount.value = moneySplit[0]
  amount.decimal = moneySplit[1]
  amount.decimal = amount.decimal * 10  if amount.decimal < 10
  draw = ->
    
    #canvas size
    
    #circle size
    
    #dynamic aspect
    
    #canvas context and default settings
    counter = ->
      if amount.value >= count
        ctx.clearRect 0, 0, canvasWidth, canvasWidth
        ctx.beginPath()
        ctx.arc canvasCenter, canvasCenter, canvasCenter - 1, circle.startAngle, circle.endAngle, false
        ctx.fillStyle = option.border
        ctx.lineWidth = 1
        ctx.strokeStyle = option.borderShadow
        ctx.stroke()
        ctx.closePath()
        ctx.fill()
        ctx.beginPath()
        ctx.arc canvasCenter, canvasCenter, canvasCenter - (aspectSmall / 2.4), circle.startAngle, circle.endAngle, false
        ctx.fillStyle = option.background
        ctx.closePath()
        ctx.fill()
        ctx.fillStyle = option.color
        ctx.font = fontBalance
        ctx.fillText option.balance, canvasCenter, canvasCenter - (aspect)
        ctx.font = fontAmount
        ctx.fillText count + option.seperator + countDecimals + option.currency, canvasCenter, canvasCenter - (aspect * -0.4)
        if countDecimals < amount.decimal
          if (amount.decimals - countDecimals) < 30 or (amount.value - count) > 100
            countDecimals++
          else
            if countDecimals + 8 <= amount.decimal
              countDecimals = countDecimals + 8
            else
              countDecimals = countDecimals + (amount.decimal - countDecimals)
        if (amount.value - count) < 4
          count++
          setTimeout counter, 80
        else if (amount.value - count) < 8
          count++
          setTimeout counter, 40
        else if (amount.value - count) < 30
          count++
          setTimeout counter, 20
        else if (amount.value - count) > 800
          count = count + 100
          setTimeout counter, 1
        else
          count = count + 8
          setTimeout counter, 1
      else
        return
    count = 0
    countDecimals = 0
    canvas = document.getElementById(option.canvasID)
    canvasWidth = canvas.offsetWidth * option.ratio
    canvas.width = canvasWidth
    canvas.height = canvasWidth
    canvasCenter = canvasWidth / 2
    aspect = (1 * canvasWidth / 8).toFixed(0)
    aspectSmall = (1 * canvasWidth / 16).toFixed(0)
    fontAmount = aspect + "pt " + option.fontAmount
    fontBalance = aspectSmall + "pt " + option.fontTxt
    ctx = canvas.getContext("2d")
    ctx.textAlign = "center"
    ctx.textBaseline = "middle"
    counter()

  dynamicIcon = ->
    
    # DYNAMIC ICONS
    fav_buffer = document.createElement("canvas")
    fav_buffer.ctx = fav_buffer.getContext("2d")
    fav_buffer.width = fav_buffer.height = 128
    fav_buffer.ctx.fillStyle = option.background
    fav_buffer.ctx.fillRect 0, 0, 128, 128
    fav_buffer.ctx.beginPath()
    fav_buffer.ctx.arc 26, 26, 6, circle.startAngle, circle.endAngle, false
    fav_buffer.ctx.fillStyle = option.color
    fav_buffer.ctx.closePath()
    fav_buffer.ctx.fill()
    fav_buffer.ctx.textBaseline = "middle"
    fav_buffer.ctx.fillStyle = option.color
    fav_buffer.ctx.font = "bold 9pt Arial"
    fav_buffer.ctx.fillText "REJSEKORT", 36, 36
    fav_buffer.ctx.textAlign = "center"
    if amount < 1000
      fav_buffer.ctx.font = "lighter 38pt sans-serif"
    else
      fav_buffer.ctx.font = "lighter 34pt sans-serif"
    fav_buffer.ctx.fillText amount.value, 64, 76
    fav_link_ios = document.createElement("link")
    fav_link_ios.rel = "apple-touch-icon-precomposed"
    fav_link_ios.href = fav_buffer.toDataURL("image/png")
    fav_link_shortcut = document.createElement("link")
    fav_link_shortcut.rel = "shortcut icon"
    fav_link_shortcut.href = fav_buffer.toDataURL("image/png")
    document.getElementsByTagName("head")[0].appendChild fav_link_ios
    document.getElementsByTagName("head")[0].appendChild fav_link_shortcut

  
  # define the public API
  API = {}
  API.drawCanvas = draw
  API.drawIcon = dynamicIcon
  API