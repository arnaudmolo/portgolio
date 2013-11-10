define ['jquery', 'd3'], ($, d3) ->
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
      rotateX = (((event.y + window.pageYOffset) / $document.height()) - 0.5) * 10

      nba_logo.style.webkitTransform = 
        "rotateX(" + rotateX + "deg) rotateY(" + -rotateY + "deg) rotateZ(0deg) translate( 0, -50px)"

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

    drawPlexio = () ->
      
      # Setup all the constants
      duration = 1600
      width = 500
      height = 300
      radius = Math.floor(Math.min(width / 2, height / 2) * 0.9)
      colors = ["#FFFFFF", "#FFB110", "#ED5845", "#35D8FB"] 

      svg = d3.select("#plexio a svg").attr("width", width).attr("height", height)

      # Test Data
      d1 = [
        label: "apples"
        value: 1
      ,
        label: "oranges"
        value: 0
      ,
        label: "pears"
        value: 0
      ,
        label: "grapes"
        value: 0
      ]
      d2 = [
        label: "apples"
        value: 1
      ,
        label: "oranges"
        value: 1
      ,
        label: "pears"
        value: 1
      ,
        label: "grapes"
        value: 1
      ]

      # Set the initial data
      data = d1
      updateChart = (dataset) ->
        arcs.data donut dataset
        arcs.transition().duration(duration).ease('bounce').attrTween "d", arcTween

      color = d3.scale.category20()
      donut = d3.layout.pie().sort(null).value (d) ->
        d.value

      arc = d3.svg.arc().innerRadius(0).outerRadius 0
      
      main_grp = svg.append("g")

      arc_grp = main_grp.append("g").attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ") rotate(-180)")
      arc_grp.transition().duration(duration).ease('bounce').attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ") rotate(-45)")
      
      arcs = arc_grp.selectAll("path").data(donut(data))
      
      arcs.enter().append("path").attr("stroke", "white").attr("stroke-width", 0.8).attr("fill", (d, i) ->
        colors[i]
      ).attr("d", arc).each (d) ->
        @current = d

      # Tween Function
      arcTween = (a) ->
        i = d3.interpolate @current, a
        @current = i 0
        (animation_time) ->
          arc.outerRadius radius*animation_time
          arc i animation_time


      # Update the data
      updateChart d2

      setTimeout () ->
        main_grp.attr 'class', 'anim'
      , 1
      
      

    drawPlexio()

    return