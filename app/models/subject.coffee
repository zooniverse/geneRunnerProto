BaseSubject= require('zooniverse/lib/models/subject')

Spine = require('spine')

class Subject extends BaseSubject
  @configure 'Subject', 'preloaded', 'location', 'metadata', 'active', 'workflow_ids','curentOffset','data',"currentOffset"
  projectName : 'cancer_gene_runner'
  
  step : 12000
  currentOffset: 0

  constructor:->
    super
    @active = false
    @getData()


  @fakeFetch:->
    for subject in require('lib/sampleSubjects')
      Subject.create(subject)
  
  getData:=>
    $.ajax
      dataType: "jsonp"
      jsonpCallback: 'data'
      url: "#{@location.standard}"
      timeout : 100000000
      
      success:(data)=>
        @parseData(data)

          

  parseData:(data)=>
    @data  = ({x: parseFloat(point[0]), y: parseFloat(point[1])} for point in data)
    @currentOffset = @data[0].x
    @active = true
    @save()
    @trigger('ready')

  range:=>
    [@data[0].x, @data[@data.length-1].x]
  
  domain:=>
    [d3.min(@data.map((d)->d.y)), d3.max(@data.map((d)->d.y))]
  
  retire:=>
    @active= false 
    @save()
    @trigger('retire')

  @getMore:->
    @fetch(1)

  @random:->
    pool = @active()
    pool[Math.floor(pool.length*Math.random())]
  
  @active:->
    @select (subject)->
      subject.active

  currentData:=>
    start= @currentOffset
    end = @currentOffset+@step
    section = (point for point in @data when point.x > start and point.x <end)

  reset:=>
    @curentOffset=0 
    @currentData()

  advance:=>
    @currentOffset += @step 
    @currentData()


module.exports = Subject