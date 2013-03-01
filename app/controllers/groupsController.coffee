Spine = require('spine')
User   = require('zooniverse/lib/models/user')
UserGroups = require('models/user_group')


class GroupsController extends Spine.Controller
  className: "groupsController"
  
  events:
    'click .subnav li' : 'switchType'
    'click .groupAccept' : 'accept'
    'click .groupDecline' : 'decline'

  constructor: ->
    super
  
  active:(params)=>
    super

    if User.current?
      @showRequest(params)
    else
      User.bind 'sign-in', =>
        alert("triggering here")
        if User.current?
          @navigate "/groups/#{params.id}/#{params.referer}"
      @navigate '/'

  showRequest:(params)=>
    if params.id?  
      @groupID = params.id
      @render {groupID: @groupID, referer: params.referer}
    else
      @navigate('/')

  accept:=>
    UserGroups.join(@groupID)
    @groupID=null
    @navigate '/'

  decline:=>
    @groupID=null
    @navigate "/"

  render:(params=null)=>
    @html require('/views/groupJoin')
      referer  :  params.referer
      user     :  User.current
  
  switchType:(e)=>
    $("ul.subnav li").removeClass('active') 
    $(e.currentTarget).addClass("active")
    type= $(e.currentTarget).data().type
    $(".subsection").removeClass('active')
    $(".subsection.#{type}").addClass("active")
        
module.exports = GroupsController 