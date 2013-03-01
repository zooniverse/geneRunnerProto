Spine = require('spine')
Subject = require('models/subject')
Tutorial = require 'zooniverse/lib/controllers/tutorial'
tutorialSteps = require 'lib/tutorialSteps'
User = require 'zooniverse/lib/models/user'

Classificaiton = require('models/classification')

class ClassificationController extends Spine.Controller
  className: "ClassificationController"
    
  elements:
    '#canvasTarget' : "drawArea"
    '#canvasTarget img' : "geneImage"
    '.slowClouds' : "slowClouds"
    '.fastClouds' : "fastClouds"
    ".backgroundSign" : "markerSigns"
    ".groupMain" : "groupMain"
    '.marker'   : 'anomolyMarkers'
    
  events:
    'click .points' : 'placeMarker'


  constructor: ->
    super
    @phase = "start"
    @render()
    @enabled=true

    Modernizr.csstransforms = false
    Modernizr.csstransforms3d = false
    $(document).on 'keypress', (e)=>
      @animate() if e.keyCode ==32 and @enabled
    
    Spine.bind('showClassifier', @showMe)
    Spine.bind('hideClassifier', @hideMe)
    @el.css('display',"none")

    Subject.bind 'ready', =>
      @showNewData()
      $('.instructions').html( " <p> Press Space to run on </p><p> Click once to mark the start of an abnormal region</p><p> Click again to mark its end point</p>" )


    Subject.getMore(1)

    
    @sectionWidth = 70000
    @sectionHeight= 600
    @enableMarking= true

    User.bind 'sign-in', =>
      @updateMilestone()
      @updateTeam()
    # if localStorage['seenTutorial']=="false"
    

  startTutorial:=>
    unless $(".tutorial").length > 0
      @tutorial = new Tutorial
        hashMatch: /^#\/classify/
        steps: tutorialSteps

      @tutorial.start()

  render:=>
    @html require('views/classifier')()
    @delay =>     
      if Modernizr.csstransforms3d
        $(".points").css('-webkit-transform', 'translate3d(200px,0px,0px)')
        $(".points").attr({'data-left': "200"})
      else
        $(".points").css('left', '200px')
      
      $(".points").css("top":"10%")

      localStorage['doneTutorial'] ||= 'false'

      if !User.current?  or localStorage['doneTutorial']!='true'
        @startTutorial()
      
      User.bind "sign-in", =>
        if User.current? and localStorage['doneTutorial']=='true'
          $(".tutorial").remove()
          @updateMilestone()
          @updateTeam()
      @updateTeam()
      @updateMilestone()
    ,200

  calculateRanges:=>
    @xRange  = d3.scale.linear().domain(@currentSubject.range()).range([0,@sectionWidth])
    @yRange  = d3.scale.linear().domain(@currentSubject.domain()).range([0,@sectionHeight])

    if Modernizr.csstransforms3d
      $(".zeroPoint").css("-webkit-transform", @transformedLocation({x:0, y:0}) )
    else
      $(".zeroPoint").css('top', @yRange(0)+"px")

  showNewData:=>

    @currentSubject ||= Subject.random()
    @currentClassification ||= new Classificaiton({subject_id : @currentSubject.id, workflow_id : @currentSubject.workflow_id})
    unless @xRange? then @calculateRanges() 

    if @currentSubject?

      data = Subject.first().currentData()

      point = d3.select("div.points").selectAll('div.point')
                .data(data, (d)->d.x)

      newPoints = point.enter().append("div")

      if Modernizr.csstransforms3d
        newPoints.attr("class","point")
          .style("-webkit-transform", @transformedLocation)
      else 
        newPoints.attr("class","point")
          .style('left', (d)=> @xRange(d.x)+"px")
          .style('top', (d)=> @yRange(d.y)+"px")
        


  removeOldData:=>
    data = Subject.first().currentData()
    point = d3.select("div.points").selectAll('div.point')
             .data(data, (d)->d.x)
    point.exit()
         .remove()
    $('.marker').remove()
    @enableMarking= true
      
  transformedLocation:(d)=>
    "translate3d(#{@xRange(d.x)}px , #{@yRange(d.y)}px, #{0}px)"

  updateTeam:=>
    if User.current?
      if User.current.user_group_id?
        groupName = (group.name for group in  User.current.user_groups when group.id == User.current.user_group_id)[0]
        $(".team").html "You are classifying as part of #{groupName} <a href='#/profile'>Switch groups</a>."
      else
        $(".team").html "You are classifying solo.<a href='#/profile'>Manage groups</a>." 
    else 
      $(".team").html "You are classifying logged out. <a href='#/login'>Login to win awards</a>."


  updateMilestone:=>
    levels = {30: 'silver', 60:'gold'}

    if User.current?
      if !User.user_group_id?
        count = @localMoveCount()
        name = User.current.name
        nextLevel = ( [level,award] for level,award of levels when  count < level)[0]
      if nextLevel?
        $(".nextMilestone").html "Only #{nextLevel[0] - count} sections till #{name} wins the #{nextLevel[1]} award"
      else 
        $(".nextMilestone").html "You have won all the awards! Congratualtions"
    else 
      $(".nextMilestone").html "Sign in to earn rewards"

  showMe:=>
    @el.fadeIn()
    if localStorage['doneTutorial'] != 'true'
      @startTutorial()
  active:=>
    super 
    if localStorage['doneTutorial'] != 'true'
      @render()

  hideMe:=>
    @el.fadeOut()
    
  selection:(e)=>
    e.preventDefault()
    xPoint = e.pageX
    yPoint = e.pageY
    
    if @selectPhase == 0
      @dropMarkerOne()
    else if @selectPhase == 1
      @dropMarkerTwo()


  confirmSelection:=>
    alert("confirm Selection")

  placeMarker:(e)=>
    if @enableMarking
      # xPos = e.pageX - $(e.currentTarget).pageX
      xPos = @xRange.invert(e.offsetX)



      if @phase == "start"
        @currentClassification.doneAnnotation()
        @currentClassification.annotateStart(xPos)
        newStartMarker = $("<div class='startMarker marker'></div>")
        if Modernizr.csstransforms3d
          newStartMarker.css({'-webkit-transform':  @transformedLocation({x:xPos, y:0})})
        else
          newStartMarker.css({'top':  @yRange(0)})
          newStartMarker.css({'left':  @xRange(xPos)})

        $(".points").append(newStartMarker)
        @phase = 'end'

      else if @phase == "end"
        @currentClassification.annotateEnd(xPos)
        newEndMarker = $("<div class='endMarker marker'></div>")
        if Modernizr.csstransforms3d
          newEndMarker.css({'-webkit-transform':  @transformedLocation({x:xPos, y:0})})
        else
          newEndMarker.css({'top':  @yRange(0)})
          newEndMarker.css({'left':  @xRange(xPos)})
          
        $(".points").append(newEndMarker)
        @phase = 'start'


 

  showSign:->
    classificationCount = parseInt(@localClassificationCount())
    if classificationCount < 10
      cc = "000#{classificationCount}"
    else if classificationCount < 100
      cc = "00#{classificationCount}"
    else if classificationCount < 1000
      cc = "0#{classificationCount}"
    else
      cc = "#{classificationCount}"

    @drawArea.append require('views/backgroundSign')({text:cc}) 

  showGroup:->
    text2= ["Keep going", 'Well Done', 'You Rock'][Math.floor(Math.random()*3)]
    text1= ["Go", 'Yay', 'Woo!'][Math.floor(Math.random()*3)]

    classificationCount = @localClassificationCount()
    @drawArea.append require('views/groupMain')({text1:text1, text2: text2}) 

  localClassificationCount:->
    idForCount = User.current?.user_group_id || User.current?.id || "loggedout"
    parseInt(localStorage["classificationCount_#{idForCount}"])

  localMoveCount:->
    idForCount = User.current?.user_group_id || User.current?.id || "loggedout"
    parseInt(localStorage["moveCount_#{idForCount}"]) || 0

  animate:=>
    @enabled=false
    @currentClassification.archiveAnnotations()
    @enableMarking= false
    @currentSubject.advance()
    @showNewData()


 
    if Modernizr.csstransforms
      @animateCssTransform()
    else
      @animateJquery()
    @delay =>
      @removeOldData()
      @showBackgroundObjects()
      @enabled=true
    , 4800

  showBackgroundObjects:=>

    idForCount = User.current?.user_group_id || User.current?.id || "loggedout"
    localStorage["moveCount_#{idForCount}"] ||= 0
    localStorage["classificationCount_#{idForCount}"] ||= 0
    localStorage["moveCount_#{idForCount}"] = @localMoveCount() + 1

    User.current.project.classification_count = @localClassificationCount()
    
    moveCount = @localMoveCount()


    if  moveCount%3 == 0
      localStorage["classificationCount_#{idForCount}"] = @localClassificationCount() + 1
      @showSign()
    
    if moveCount%10 ==0
      @showGroup()

    if moveCount == 30
      @navigate '/award/10'

    else if moveCount == 60
      @navigate '/award/20'

    @updateMilestone()

  animateJquery:=>
    slowX = parseInt(@slowClouds.css('background-position-x')) 
    fastX = parseInt(@fastClouds.css('background-position-x')) 

    left = -@xRange(@currentSubject.currentOffset) + 300

    @slowClouds.animate({'background-position-x': slowX - 70}, 4000)
    @fastClouds.animate({'background-position-x': fastX - 20},4000 )
    $(".backgroundSign").animate({"right": "-=#{left}"}, 4000)
    $(".groupMain").animate({"right": "-=#{left}"}, 4000)
    $('.points').animate({'left':left}, 4000)

  animateCssTransform:=>

    left = - @xRange(@currentSubject.currentOffset)+300
    @slowClouds.css("background-position", '-=70')
    @fastClouds.css("background-position", '-=20')
    $(".backgroundSign").css("right", "-=#{left}")

    $(".groupMain").css("right", "-=#{left}")


    $(".points").attr("data-left", left)
    $('.points').css('-webkit-transform', "translate3d(#{left}px,0px,0px)")




  
module.exports = ClassificationController