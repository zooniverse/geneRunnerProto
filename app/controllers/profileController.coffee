Spine  = require('spine')
User   = require('zooniverse/lib/models/user')
UserGroups   = require('models/user_group')

class ProfileController extends Spine.Controller
  className: "profileController"

  elements:
    ".mailInviteAddress" : 'mailAddress'

  events: 
    'click .mailInvite' : 'mailInvite'
    'change .groupSelect' : 'selectGroup'
    'click .createGroup' : 'createGroup'
    'click .invite a'    : 'dissableSocial'
  constructor: ->
    super
    @render()

    User.bind "sign-in", @render
    User.bind "updateProfile", @render
    UserGroups.bind "participate", @fetchGroup

  active:=>
    unless User.current?
      @navigate "/login"
    else
      super
      if User.current.user_group_id?
        fetchGroup()
      @render()

  dissableSocial:(e)=>
    e.preventDefault()
    alert('social media is dissabled in the beta')

  inviteLink:=>
    "#{window.location.origin}/#/groups/#{User.current.user_group_id}/#{User.current.name}"

  selectGroup:(e)=>
    groupID = $(".groupSelect").val()


    if groupID=='solo'
      UserGroups.stop()
      @currentGroup=null
      @render()
    else 
      UserGroups.participate(groupID).onSuccess (group)=>
        @currentGroup= group
        @render()

  createGroup:=>
    UserGroups.newGroup( "#{User.current.name}'s running group" ,false).onSuccess =>
      User.fetch().onSuccess =>
        @render()

  mailInvite:(e)=>
    e.preventDefault()
    email = $(@mailAddress).val()
    window.location.href ="mailto:#{email}?subject=Come Join my group and fight Cancer&body=Follow this link #{escape(@inviteLink())} to join the group" 

  fetchGroup:=>
    UserGroups.fetch(User.current.id).onSuccess (group)=>
      @currentGroup = group
      @render()

  render:=>
    idForCount = User.current?.user_group_id || User.current?.id || "loggedout"
    awardCount = parseInt(localStorage["classificationCount_#{idForCount}"])

    if User.current?
      @html require('/views/profile')
        user: User.current
        groupUrl : @inviteLink()
        group : @currentGroup
        hasOwnGroup: UserGroups.userHasOwnGroup
        awardCount: awardCount

    else 
      @html require '/views/profileLogInPrompt'



     
module.exports = ProfileController 