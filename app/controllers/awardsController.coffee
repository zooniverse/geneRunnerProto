Spine = require('spine')

class AwardsController extends Spine.Controller
  className: "awardsController"
  events:
    'click .continue' : "continue"

  constructor: ->
    super

  active:(params)=>
    super 
    @render params.level

  render:(level)=>
    @html require('/views/award')
      level : parseInt(level)
    @delay =>
      $('.social a').click @dissableSocial
    ,200

  dissableSocial:(e)=>  
    e.preventDefaut()
    alert('Social Media dissabled for beta')
  
  continue:=>
    @navigate '/classify'

    
module.exports = AwardsController