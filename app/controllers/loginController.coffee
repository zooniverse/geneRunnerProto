Spine = require('spine')
User  = require('zooniverse/lib/models/user')
Api = require('zooniverse/lib/api')

class LoginController extends Spine.Controller
  className: "loginController"

  elements :
    ".login"    : 'loginForm'
    ".register" : 'registerForm'
    ".flash"    : 'flash'
    ".privacyOptIn" : "privacyCheckBox"
    
  events:
    'submit .login'    : 'login'
    'submit .register' : 'register'

  constructor: ->
    super
    @render()

    User.bind 'sign-in-error', (error)=>
      @flash.html error

    User.bind 'sign-in', =>
      if User.current?
        if @extraLoginDetails?
          @postSensitiveInfo() 
          @navigate '/'


  postSensitiveInfo:=>
    if @extraLoginDetails?
      Api.post '/users/extra_info', extra_info: @extraLoginDetails
      @delay ->
        @extraLoginDetails=null
      ,1000


  render:=>
    @html require('views/loginSignup')

  active:=>
    if User.current?
      Spine.Route.navigate '/profile'
    else
      super
      
  
  login:(e)=>
    e.preventDefault()
    details = @loginForm.serializeArray()
    User.login username:details[0].value, password:details[1].value

  register:(e)=>
    e.preventDefault()
    errors= []
    details = {}
    extraDetails={}

    for pair in @registerForm.serializeArray()
      name = pair.name.toLowerCase()
      if ["username","password","password_confirmation","email"].indexOf(name) >=0 
        details[name] = pair.value
      else
        extraDetails[name] = pair.value
    
    extraDetails['emailOptIn']      = @privacyCheckBox.is(":checked") 
    extraDetails['mailPhoneOptOut'] = @privacyCheckBox.is(":checked") 


    unless @privacyCheckBox.is(":checked") 
      errors.push "Please agree to the privacy policy"
    if details.username== "" 
      errors.push "Please enter a username"
    if details.email== "" 
      errors.push  "Please enter an email"
    if details.password =="" or details.password_confirmation==""
      errors.push  "Please enter and confirm your password"
    if details.password != details.password_confirmation
      errors.push "Passwords dont match "
      
    
    if errors.length > 0
      User.trigger 'sign-in-error', errors.join(", ")
    else
      @extraLoginDetails = extraDetails
      User.signup details


module.exports = LoginController