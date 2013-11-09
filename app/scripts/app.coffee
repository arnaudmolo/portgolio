define ['jquery'], ($) ->
  'use strict'
  new ->

    articles = $ 'header>article'
    ouvertureAnimation = $ '#ouverture animate'
    letter = $ '#letter'
    header = $ 'body>header'
    nba_logo = document.getElementById 'nba-logo'
    $document = $ document
    $window = $ window

    positionNba = (event) ->
      rotateY = ((event.x / $window.width()) - 0.5) * 10
      rotateX = ((event.y / $window.height()) - 0.5) * 10

      nba_logo.style.webkitTransform = 
        "rotateX(" + rotateX + "deg) rotateY(" + rotateY + "deg) rotateZ(0deg)"    

    $('#morning>div.center').load '/images/coffe.svg'
    $('#afternoon>div.center').load '/images/crayon.svg'
    $('#evening>div.center').load '/images/beer.svg'
    
    header.height window.innerHeight

    window.onresize = ->
      header.height window.innerHeight

    articles.mouseenter ->
      $this = $ @
      $this.toggleClass 'main'
      articles.not($this).addClass 'blackout'

    articles.mouseleave ->
      $this = $ @
      $this.toggleClass 'main'
      articles.not($this).removeClass 'blackout'

    document.addEventListener 'mousemove', positionNba

    @do = () ->
      console.log 'do'

    return