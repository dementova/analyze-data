var Chart = (function() {
  var _statusClr = {
    passed: '#39bc05',
    stopped: '#cbcbd8',
    failed: '#ff9570',
    error: '#ef2821'
  }

  var _formatting_builds = function(items) {
    var date, dates, series;
    dates = [];
    series = {
      passed: [],
      stopped: [],
      failed: [],
      error: []
    };
    for (date in items) {
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

  var _buildStatusChart = function(builds) {
    var data = _formatting_builds(builds);
    return Highcharts.chart('status', {
      chart: {
        type: 'column'
      },
      title: {
        text: 'Passing and failing builds per day'
      },
      xAxis: {
        categories: data.dates
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Total amount builds'
        }
      },
      legend: {
        align: 'right',
        verticalAlign: 'top'
      },
      tooltip: {
        headerFormat: '<b>{point.x}</b><br/>',
        pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
      },
      plotOptions: {
        column: {
          stacking: 'normal'
        }
      },
      series: [
        {
          name: 'Passed',
          data: data.series.passed,
          color: _statusClr.passed
        }, {
          name: 'Stopped',
          data: data.series.stopped,
          color: _statusClr.stopped
        }, {
          name: 'Failed',
          data: data.series.failed,
          color: _statusClr.failed
        }, {
          name: 'Error',
          data: data.series.error,
          color: _statusClr.error
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