ready = ->
  Chart =
    form: $('#form-load')
    notification: $('.msg-error')

    init: ->
      self = this

      @form.on 'submit', (e) ->
        e.preventDefault();
        self._setNotification('')
        
        formData = new FormData(e.target)
        $.post
          url: e.target.action
          data: formData
          dataType: 'json'
          processData: false
          contentType: false
          success: ( response ) ->
            if response.error
              self._setNotification( response.error_msg )
            else
              self._buildStatusChart(response.builds)
              self._buildDurationByDateChart(response.durations)
              self._buildOutliers(response.outliers)

    _setNotification: (message) ->
      @notification.html( message )

    _buildStatusChart: (builds) ->
      data = @_formatting_builds(builds)

      Highcharts.chart 'status',
        chart: 
          type: 'column'
        title: 
          text: 'Passing and failing builds per day'
        xAxis: 
          categories: 
            data.dates
        yAxis:
          min: 0
          title: 
            text: 'Total amount builds'
        legend:
          align: 'right'
          verticalAlign: 'top'
        tooltip:
          headerFormat: '<b>{point.x}</b><br/>'
          pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
        plotOptions: column:
          stacking: 'normal'
          dataLabels:
            enabled: true
            color: Highcharts.theme and Highcharts.theme.dataLabelsColor or 'white'
        series: [
          { name: 'Passed', data: data.series.passed }
          { name: 'Stopped', data: data.series.stopped }
          { name: 'Failed', data: data.series.failed }
          { name: 'Error', data: data.series.error }
        ]

    _buildDurationByDateChart: (durations) ->
      Highcharts.chart 'duration',
        chart: 
          type: 'areaspline'
        title: 
          text: 'Created_at vs Duration'
        xAxis: 
          categories: Object.keys(durations)
          title: 
            text: 'Created_at'
        yAxis: 
          title: 
            text: 'Duration'
        legend: 
          enabled: false
        credits: 
          enabled: false
        plotOptions: 
          areaspline: 
            fillOpacity: 0.5
        series: [ { name: 'Duration', data: Object.values(durations) } ]

    _buildOutliers: (outliers) ->
      Highcharts.chart 'outliers',
        chart: 
          type: 'areaspline'
        title: 
          text: 'Outliers'
        xAxis:
          categories: Object.keys(outliers)
          title: 
            text: 'Created_at'
        yAxis: 
          title: 
            text: 'Standard deviation of the arithmetic mean'
        legend: 
          enabled: false      
        tooltip: pointFormat: '{point.y}'
        plotOptions: 
          areaspline:
            fillOpacity: 0.5
        series: [{
          data: Object.values(outliers)
        }]

    _formatting_builds: (items) ->
      dates = []
      series = { passed: [], stopped: [], failed: [], error: [] }
      for date of items
        dates.push( date )
        series.passed.push( items[date].passed || 0 )
        series.stopped.push( items[date].stopped || 0 )
        series.failed.push( items[date].failed || 0 )
        series.error.push( items[date].error || 0 )
      { dates: dates, series: series }

  Chart.init();

$(document).ready(ready)