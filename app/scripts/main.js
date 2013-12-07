
require.config({
  paths: {
    jquery: "../bower_components/jquery/jquery",
    d3: "../bower_components/d3/d3"
  },
  shim: {
    d3: {
      exports: 'd3'
    }
  }
});

require(["app", "jquery"], function(app) {});
