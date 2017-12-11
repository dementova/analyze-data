var Chart = (function() {
  var _statusClr = {
    passed: '#39bc05',
    stopped: '#cbcbd8',
    failed: '#ff9570',
    error: '#ef2821'
  }

  var _deviationClr = {
    both: '#ef2821',
    one: '#ff9570'
  }

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

  var _buildStatusChart = function(builds, deviations) {
    builds = _formattingBuilds(builds);
    return Highcharts.chart('status', {
      chart: {
        type: 'column'
      },
      title: {
        text: 'Passing and failing builds per day'
      },
      xAxis: {
        categories: builds.dates,
        labels: {
          formatter: function () {
            if (deviations.by_test.indexOf(this.value) != -1 && deviations.by_duration.indexOf(this.value) != -1) {
              return '<span style="fill: '+_deviationClr.both+';">' + this.value + '</span>';
            } else if(deviations.by_duration.indexOf(this.value) != -1) {
              return '<span style="fill: '+_deviationClr.one+';">' + this.value + '</span>';
            } else {
              return this.value;
            }
          }
        }
      },
      yAxis: {
        title: {
          text: 'Total amount builds'
        }
      },
      legend: {
        align: 'right',
        verticalAlign: 'top'
      },
      tooltip: {
        shared: true,
        headerFormat: '<b>{point.x}</b><br/>',
        pointFormat: '{series.name}: {point.y} / {point.stackTotal} <br>'
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
          data: builds.series.passed,
          color: _statusClr.passed
        },{
          name: 'Stopped',
          data: builds.series.stopped,
          color: _statusClr.stopped
        },{
          name: 'Failed',
          data: builds.series.failed,
          color: _statusClr.failed
        },{
          name: 'Error',
          data: builds.series.error,
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

  return {
    buildStatusChart : _buildStatusChart,
    buildDurationByDateChart : _buildDurationByDateChart
  }

})();