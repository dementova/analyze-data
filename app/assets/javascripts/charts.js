var Chart = (function() {
  var _statusClr = {
    passed: '#39bc05',
    stopped: '#cbcbd8',
    failed: '#ff9570',
    error: '#ef2821'
  }

  var _avrDurationClr = 'rgba(68, 170, 213, .4)';

  var _formattingBuilds = function(items) {
    var dates, series;
    dates = [];
    series = {
      passed: [],
      stopped: [],
      failed: [],
      error: []
    };
    for (var date in items) {
      dates.push(date);
      series.passed.push(items[date].passed || 0);
      series.stopped.push(items[date].stopped || 0);
      series.failed.push(items[date].failed || 0);
      series.error.push(items[date].error || 0);
    }
    return {
      dates: dates,
      series: series
    };
  }

  var _markingDeviation = function(outliers, abnormal) {
    var result, point;
    result = [];
    for (date in outliers){
      point = { y: outliers[date] }
      if(outliers[date] >= abnormal){
        point.marker = {
          lineWidth: 2,
          fillColor: 'red',
          lineColor: 'red'
        }
      }
      result.push( point )
    }
    return result
  }

  var _buildStatusChart = function(builds, outliers, avrDuration) {
    builds = _formattingBuilds(builds);
    outliers = _markingDeviation(outliers, 100); //define k=100
    return Highcharts.chart('status', {
      chart: {
        zoomType: 'xy'
      },
      title: {
        text: 'Passing and failing builds per day'
      },
      xAxis: {
        categories: builds.dates,
        crosshair: true   
      },
      yAxis: [{
        title: {
          text: 'Standard deviation of the arithmetic mean'
        },
        plotLines: [{
          color: _avrDurationClr,
          value: avrDuration,
          width: 1
        }]
      },{
        title: {
          text: 'Total amount builds'
        },
        opposite: true        
      }],
      legend: {
        align: 'right',
        verticalAlign: 'top'
      },
      tooltip: {
        shared: true
      },
      plotOptions: {
        column: {
          stacking: 'normal'
        },
        series: {
          animation: {
            duration: 2000
          }
        },
      },
      series: [
        {
          name: 'Passed',
          type: 'column',
          yAxis: 1,
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y} / {point.stackTotal} <br>'
          },
          data: builds.series.passed,
          color: _statusClr.passed
        },{
          name: 'Stopped',
          type: 'column',
          yAxis: 1,
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y} / {point.stackTotal} <br>'
          },
          data: builds.series.stopped,
          color: _statusClr.stopped
        },{
          name: 'Failed',
          type: 'column',
          yAxis: 1,
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y} / {point.stackTotal} <br>'
          },
          data: builds.series.failed,
          color: _statusClr.failed
        },{
          name: 'Error',
          type: 'column',
          yAxis: 1,
          tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y} / {point.stackTotal} <br>'
          },
          data: builds.series.error,
          color: _statusClr.error
        },{
          name: 'test',
          type: 'spline',
          data: outliers,
          tooltip: {
            pointFormat: '{point.y}'
          }
        }
      ]
    });
  }

  var _buildDurationByDateChart = function(durations) {
    return Highcharts.chart('duration', {
      chart: {
        type: 'areaspline'
      },
      title: {
        text: 'Created_at vs Duration'
      },
      xAxis: {
        categories: Object.keys(durations),
        title: {
          text: 'Created_at'
        }
      },
      yAxis: {
        title: {
          text: 'Duration'
        }
      },
      legend: {
        enabled: false
      },
      credits: {
        enabled: false
      },
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5
        },
        series: {
          animation: {
            duration: 2000
          }
        }
      },
      series: [
        {
          name: 'Duration',
          data: Object.values(durations)
        }
      ]
    });
  }

  var _buildOutliers = function(outliers) {
    return Highcharts.chart('outliers', {
      chart: {
        type: 'areaspline'
      },
      title: {
        text: 'Outliers'
      },
      xAxis: {
        categories: Object.keys(outliers),
        title: {
          text: 'Created_at'
        }
      },
      yAxis: {
        title: {
          text: 'Standard deviation of the arithmetic mean'
        }
      },
      legend: {
        enabled: false
      },
      tooltip: {
        pointFormat: '{point.y}'
      },
      plotOptions: {
        areaspline: {
          fillOpacity: 0.5
        }
      },
      series: [
        {
          data: Object.values(outliers)
        }
      ]
    });
  }
    
  return {
    buildStatusChart : _buildStatusChart,
    buildDurationByDateChart : _buildDurationByDateChart,
    buildOutliers : _buildOutliers
  }

})();