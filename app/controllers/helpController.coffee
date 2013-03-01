Spine = require('spine')

class HelpController extends Spine.Controller
  className: "helpController"

  events:
    'click .helpNav li' : 'switchType'
    'click .redoTutorial': 'restartTutorial'

  constructor: ->
    super
    @render()

  render:=>
    @html require('/views/help')
  
  restartTutorial:=>
    localStorage['doneTutorial']= 'false'
    @navigate "/classify"

  switchType:(e)=>
    $("li").removeClass('active')
    $(e.currentTarget).addClass("active")
    type= $(e.currentTarget).data().type
    $(".cellType").removeClass('active')
    $(".cellType.#{type}").addClass("active")



    
module.exports = HelpController