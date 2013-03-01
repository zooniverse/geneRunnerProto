Spine = require('spine')

class InfoController extends Spine.Controller
  className: "infoController"
  
  events:
    'click .subnav li' : 'switchType'

  constructor: ->
    super
    @render()

  render:=>
    @html require('/views/info')
  
  switchType:(e)=>
    $("ul.subnav li").removeClass('active')

    $(e.currentTarget).addClass("active")
    type= $(e.currentTarget).data().type
    $(".subsection").removeClass('active')
    $(".subsection.#{type}").addClass("active")
        
module.exports = InfoController