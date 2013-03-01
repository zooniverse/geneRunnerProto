Spine                = require('spine')

infoController       = require('controllers/infoController')
helpController       = require('controllers/helpController')
profileController    = require('controllers/profileController')
loginController      = require('controllers/loginController')
groupsController     = require('controllers/groupsController')
awardController      = require('controllers/awardsController')


class ContentController extends Spine.Stack
  
  controllers:
    'login'     : loginController
    'info'      : infoController
    'help'      : helpController
    'profile'   : profileController
    'groups'    : groupsController 
    'awards'    : awardController


  switch :(params)=>
    
    if params.match[0]=='/'
      Spine.trigger("showHome")
      Spine.trigger("hideClassifier")
      if Modernizr.csstransforms?
        $('.stack > *').removeClass('active')
        $('.stackOuter').removeClass('trans')
      

    else if params.match[0]=='/classify'
      Spine.trigger("hideHome")
      Spine.trigger("showClassifier")
      $('.stack > *').removeClass('active')
      $(".stackOuter").removeClass('trans')
    else
      $(".stackOuter").addClass('trans')


  routes:
    
    '/info'      : (params)-> @switch(params); @info.active()
    '/help'      : (params)-> @switch(params); @help.active()
    '/profile'   : (params)-> @switch(params); @profile.active()
    '/login'     : (params)-> @switch(params); @login.active()
    '/'          : (params)-> @switch(params)
    '/classify'  : (params)-> @switch params
    '/groups/:id/:referer'    : (params)-> @switch(params); @groups.active(params) 
    '/award/:level' : (params)-> @switch(params);  @awards.active(params)
    
module.exports = ContentController