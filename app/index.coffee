require('lib/setup')

Spine = require('spine')
TopBar = require('zooniverse/lib/controllers/top_bar')
Api = require('zooniverse/lib/api')
Config = require('lib/config')
googleAnalytics = require('zooniverse/lib/google_analytics')
ClassificationController= require("controllers/classificationController")
ContentController = require("controllers/contentController")
HomeController = require('controllers/homeController')

class CustomTopbar extends TopBar
  
  constructor :->
    super 
    $("button[name=signup]").on 'click', @startSignUp
 
  startSignUp:=>
    Spine.trigger 'start'
    @navigate '#/login'

  render:=>
    super 
    $("#zooniverse-top-bar-projects").html("<img width=125px src='images/cancerLogo.png'></img>")
    $(".zooniverse-top-bar #zooniverse-top-bar-container #zooniverse-top-bar-info h3").html("<span id='app-name'>Cell Slider</span> is a collaboration between <strong>CRUK</strong> and <strong>Zooniverse</strong>")
    $(".zooniverse-top-bar #zooniverse-top-bar-container #zooniverse-top-bar-info p").remove()

class App extends Spine.Controller
  elements:
    '.stackOuter' : 'outer'

  constructor: ->
    super
    
    @append  new ClassificationController()

    @append new HomeController()
    Api.init host: Config.apiHost
    
    # googleAnalytics.init account: 'UA-1224199-34', domain: 'generunner.net'
    
    topBar = new CustomTopbar
      el: '.zooniverse-top-bar'
      languages:
        en: 'English'
      app: 'cancer_cells'
      appName:'GeneRunner'


    $(".dialog-underlay").remove()
    @outer.append (new ContentController()).el
    Spine.Route.setup()
    @preloadAssets()

  preloadAssets:=>
    for asset in require('lib/preloadList')
      img = new Image()
      img.src= asset

module.exports = App
    