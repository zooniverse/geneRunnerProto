Spine       = require('spine')
User        = require('zooniverse/lib/models/user')
UserGroups  = require('models/user_group')


class HomeController extends Spine.Controller
  className: "homeController"

  elements :
    '.centralContent'     : 'central'
    'form.signIn'         : "signInForm"
    'form.selectGroup'    : "groupSelectForm"


  events:
    'submit .signIn'       : "signIn"
    'submit .selectGroup'  : "selectGroup"
    'click .signup'        : "signup"
    'click .startNoSignIn' : "startNoSignIn"
    'click .rerunTutorial' : 'rerunTutorial'
    'click .createYourGroup' : 'createYourGroup'

  constructor: ->
    super
    Spine.bind 'showHome', @showMe
    Spine.bind 'hideHome', @hideMe

    User.bind 'sign-in', @render
    User.bind 'sign-in-error', (details) => 
      @loginError = details 
      @render()

    @render()



  render:=>
    @html require('/views/home')

    @delay ->
      if User.current?
        $(".centralContent").html require('/views/homeLoggedIn')
          user: User.current
          hasOwnGroup: UserGroups.userHasOwnGroup()
        if User.current.user_group_id?
          $(".groupSelect").val(User.current.user_group_id)
      else 
        $(".centralContent").html  require('/views/homeLoggedOut')
          details: @loginError
      @refreshElements()
    ,200

  showMe:=>
    $(@.el).css('display', 'block')

  hideMe:=>
    $(@.el).fadeOut()

  signIn:(e)=>
    e.preventDefault()
    details = @signInForm.serializeArray()
    User.login({username: details[0].value, password: details[1].value})
    $(".centralContent").html("<h2>Logging in...</h2>")

  createYourGroup:=>
    @navigate "/profile"
  selectGroup:(e)=>
    e.preventDefault()
    details = @groupSelectForm.serializeArray()
    
    unless details[0].value == 'solo'
      @groupParticipate(details[0].value)

    @navigate('#/classify')

  startNoSignIn:=>
    @navigate '/classify'

  signup:=>
    @navigate '/login'

  rerunTutorial:=>
    localStorage['doneTutorial']= 'false'
    @navigate "/classify"

  groupParticipate:(id)=>
    UserGroups.participate(id)
    User.trigger('participate')


  go:(e)=>
    e.preventDefault()
    @navigate '#/classify'
 
module.exports = HomeController