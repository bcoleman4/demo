class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  require 'sidekiq/api'
  def home
  	#render text: "This is Home"
    Sidekiq::Queue.new.clear
    GuestsCleanupJob.set(wait: 5.seconds).perform_later()
    #GuestsCleanupJob.perform_later
  end

  def help
  	#render text: "This is help"
  end

  def about
  end

  def contact
  end
  
  def survey
  end

  def pdf
    #function :create_a_pdf
    #img = "#{Prawn::DATADIR}/images/ferrari.png"
    Prawn::Document.generate("chart.pdf",
    #:background => img,
    :margin => 100
    ) do
      text "Your chart #{@chart}"
      text "My report caption", :size => 18, :align => :right
      move_down font.height * 2
      text "Here is my text explaning this report. " * 20,
      :size => 12, :align => :left, :leading => 2
      move_down font.height
      text "I'm using a soft background. " * 40,
      :size => 12, :align => :left, :leading => 2
    end
  end

  def chart
    @chart = LazyHighCharts::HighChart.new('bar') do |f|
      f.title(text: "Purpose and Fulfilment")
      f.xAxis(categories: ["TOTAL SCORE", "Meaning and Purpose", "General Engagement", "Work Engagement", "Perseverence", "Learning and Growth" ])
      f.series(:type=> 'bar', name: "Your Score", yAxis: 0, data: [6.6, 6.9, 4.2, 5.6, 6.3, 9.4])
      f.series(:type=> 'scatter', name: 'Average', yAxis: 0, data: [5.0, 6.0, 2.0, 4.6, 5.5, 9.0])
      f.yAxis [
        {title: {text: "Your Score", margin: 70} },
        ]
      f.plotOptions({bar: {dataLabels: {enabled: true }}})
      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
      end

    @chart2 = LazyHighCharts::HighChart.new('polar') do |f|
      f.title(text: "Purpose and Fulfilment")
      f.chart(:polar=> true)
      f.xAxis(categories: ["TOTAL SCORE", "Meaning and Purpose", "General Engagement", "Work Engagement", "Perseverence", "Learning and Growth" ], tickmarkPlacement: 'on')
      f.series(:type=> 'line', name: "Your Score", yAxis: 0, data: [6.6, 6.9, 4.2, 5.6, 6.3, 9.4], pointPlacement: 'on')
      f.series(:type=> 'area', name: 'Average', yAxis: 0, data: [5.0, 6.0, 2.0, 4.6, 5.5, 9.0])
      f.yAxis [
        {gridlineInterpolation: 'polygon' },
        ]
    end

    @chart3 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Population vs GDP For Really Big Countries [2009]")
      f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
      f.series(name: "GDP in Billions", yAxis: 0, data: [14119, 5068, 4985, 3339, 2656])
      f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])

      f.yAxis [
        {title: {text: "GDP in Billions", margin: 70} },
        {title: {text: "Population in Millions"}, opposite: true},
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
    end

    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 2,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
  end
end
