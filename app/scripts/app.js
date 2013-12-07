
define(['jquery', 'd3'], function($, d3) {
  'use strict';
  return new function() {
    var $document, $window, articles, drawPlexio, header, letter, nba_logo, ouvertureAnimation, plexio_logo, positionNba, runChart;
    articles = $('header>article');
    ouvertureAnimation = $('#ouverture animate');
    letter = $('#letter');
    header = $('body>header');
    nba_logo = document.getElementById('nba-logo');
    plexio_logo = document.getElementById('plexio-logo');
    $document = $(document);
    $window = $(window);
    positionNba = function(event) {
      var rotateX, rotateY;
      rotateY = ((event.x / $window.width()) - 0.5) * 10;
      rotateX = (((event.y + window.pageYOffset) / $document.height()) - 0.5) * 10;
      nba_logo.style[Modernizr.prefixed('transform')] = "rotateX(" + rotateX + "deg) rotateY(" + -rotateY + "deg) rotateZ(0deg) translate( 0, -50px)";
      return plexio_logo.style[Modernizr.prefixed('transform')] = "rotateX(" + rotateX * 2 + "deg) rotateY(" + -rotateY * 2 + "deg) rotateZ(0deg) translate( 0, -50px)";
    };
    $('#morning>div.center').load('/images/coffe.svg');
    $('#afternoon>div.center').load('/images/crayon.svg');
    $('#evening>div.center').load('/images/beer.svg');
    header.height(window.innerHeight);
    window.onresize = function() {
      return header.height(window.innerHeight);
    };
    articles.mouseenter(function() {
      var $this;
      $this = $(this);
      $this.toggleClass('main');
      return articles.not($this).addClass('blackout');
    });
    articles.mouseleave(function() {
      var $this;
      $this = $(this);
      $this.toggleClass('main');
      return articles.not($this).removeClass('blackout');
    });
    document.addEventListener('mousemove', positionNba);
    drawPlexio = function() {
      var arc, arcTween, arc_grp, arcs, color, colors, d1, d2, data, donut, duration, height, main_grp, radius, svg, updateChart, width;
      duration = 1600;
      width = 500;
      height = 300;
      radius = Math.floor(Math.min(width / 2, height / 2) * 0.9);
      colors = ["#FFFFFF", "#FFB110", "#ED5845", "#35D8FB"];
      svg = d3.select("#plexio a svg").attr("width", width).attr("height", height);
      d1 = [
        {
          label: "apples",
          value: 1
        }, {
          label: "oranges",
          value: 0
        }, {
          label: "pears",
          value: 0
        }, {
          label: "grapes",
          value: 0
        }
      ];
      d2 = [
        {
          label: "apples",
          value: 1
        }, {
          label: "oranges",
          value: 1
        }, {
          label: "pears",
          value: 1
        }, {
          label: "grapes",
          value: 1
        }
      ];
      data = d1;
      updateChart = function(dataset) {
        arcs.data(donut(dataset));
        return arcs.transition().duration(duration).ease('bounce').attrTween("d", arcTween);
      };
      color = d3.scale.category20();
      donut = d3.layout.pie().sort(null).value(function(d) {
        return d.value;
      });
      arc = d3.svg.arc().innerRadius(0).outerRadius(0);
      main_grp = svg.append("g");
      arc_grp = main_grp.append("g").attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ") rotate(-180)");
      arc_grp.transition().duration(duration).ease('bounce').attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ") rotate(-45)");
      arcs = arc_grp.selectAll("path").data(donut(data));
      arcs.enter().append("path").attr("stroke", "white").attr("stroke-width", 0.8).attr("fill", function(d, i) {
        return colors[i];
      }).attr("d", arc).each(function(d) {
        return this.current = d;
      });
      arcTween = function(a) {
        var i;
        i = d3.interpolate(this.current, a);
        this.current = i(0);
        return function(animation_time) {
          arc.outerRadius(radius * animation_time);
          return arc(i(animation_time));
        };
      };
      updateChart(d2);
      return setTimeout(function() {
        return main_grp.attr('class', 'anim');
      }, 1);
    };
    runChart = function(event) {
      if (plexio_logo.getClientRects()[0].top - window.pageYOffset <= 0) {
        drawPlexio();
        return document.removeEventListener('scroll', runChart);
      }
    };
    runChart();
    document.addEventListener('scroll', runChart, false);
  };
});
