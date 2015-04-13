$( document ).ready(function() {
    capitalized_phrases_chart();
    //$(".speaker blockquote").readmore({ maxHeight: 100 });
});

function capitalized_phrases_chart() {
    var data = {
      // A labels array that can contain any sort of values
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      // Our series array that contains series objects or in this case series data arrays
      series: [
        [5, 2, 4, 2, 0]
      ]
    };

    var options = {
        height: 300,
        reverseData: true,
        horizontalBars: true,
        axisY: {
          offset: 280,
          scaleMinSpace: 0
        }
    }

    // Create a new line chart object where as first parameter we pass in a selector
    // that is resolving to our chart container element. The Second parameter
    // is the actual data object.
    new Chartist.Bar('.ct-chart', capitalized_phrases, options);
}
