module.exports = [ 
          title: "Welcome to SETILive "
          text: "SETILive is an exciting new project to try and detect Extraterrestrial signals"
          location: [270,130]
          speed:400
        ,
          title: "Real Time"
          text: "The data you can see here is coming directly from the ATA (a telescope in California). We need your help to try and discover interesting signals in that data."
          location: [270,130]
          speed:400 
        ,
          title: "Current Targets"
          text: "Right now the telescope is looking at the stars you can see indicated here. It's listening for interesting data."
          indicatorPos: "left top"
          location: [660,-185]
          speed:400
        ,
          title: "Current Targets"
          text: "You can see details of the current targets here, and if you click on them you can see even more info."
          location: [544,215]
          indicatorPos: "top right"
          speed:400
        ,
          title: "Beams"
          text: "You will notice that the telescope can look at more than one target at a time. It does this by forming two beams. The latest data from each beam is shown here."
          location: [590, 340]
          indicatorPos: "bottom left"
          speed:400
        ,
          title: "Main Beam"
          text: "We will work on one beam at a time. The main display shows the data from the current beam."
          location: [24,126]
          indicatorPos: "top right"
          speed:400
        ,
          title: "Waterfalls"
          text: "We need you to mark anything that looks like a signal on this plot. Signals are distinct patterns on the waterfall like the one you can see here."
          location: [24,126]
          speed:400
          indicatorPos: "top right"
       ,
          title: "More Examples"
          text: "You can see more examples of interesting signals by clicking 'signals' at any time."
          onShow: ->
               $("#nav li.nav_about").addClass("tutorial_select")
               $("#nav li.tutorial_signals").addClass("tutorial_item_selected ")

          onLeave: ->
               $("#nav li.nav_about").removeClass("tutorial_select")
               $("#nav li.tutorial_signals").removeClass("tutorial_item_selected")

          location: [400,-270]
          speed:400
       , 
          title: "Markers"
          text: "Start by clicking anywhere along the bright signal you can see here"
          prompt: "Click a point"
          triggers: [{elements : ".large-waterfall", action: "click"}]
          disableControls: true
          location: [24,126]
          speed:400
        ,
          title: "Lines",
          text: "Great! you can move this marker around by grabbing it with your mouse. Next click a second point along the signal.",
          location: [360,-40]
          indicatorPos: "bottom left"
          triggers: [{elements : ".large-waterfall", action: "click"}]
          disableControls: true
          prompt: "Click a second point"
          speed:400
        ,
          title: "Describe",
          text: "You can adjust the line showing where the signal is by moving either marker. We will ask you to descibe the signal now. Give it a try.",
          triggers: [{elements : ".answer", action: "click"}]
          disableControls: true
          location: [520,24]
          prompt: "Describe the signal"
          speed:400
        ,
          title: "Repeat"
          text: "Do this for each signal you can see in the data. Once you're done, click here to move on.",
          location: [544,304]
          disableControls: true
          triggers: [{elements : "#next_beam", action: "click"}]
          prompt: "Click next beam"
          indicatorPos: "right bottom "
          speed:400
        ,
          title: "Repeat"
          text: "This will move you on to the second beam. You can always go back to the first by clicking on it."
          location: [60,304]
          indicatorPos: "right bottom "
          speed:400
        ,
          title: "Done"
          text: "Once you're done, click here."
          disableControls: true
          triggers: [{elements : "#done", action: "click"}]
          prompt: "Click to finish"
          location: [544,304]
          indicatorPos: "bottom right"
          speed:400
        ,
          title: "Talk"
          text: "If you have seem anything unusual and want to talk about it or see what other people have said, click yes."
          onShow: ->
            $("#talkYes").unbind('click')
            $("#talkNo").unbind('click')
          location: [544,304]
          speed:400
        ,
          title: "Badges"
          onShow: ->
               User.trigger("tutorial_badge_awarded")
          text: "You can earn badges for various things on the site. These, along with other notifications of what the telescope is doing, will appear here."
          location: [780,-80]
          speed:400
          indicatorPos: "top left"

        ,
          title: "Profile"
          text: "You can check out every signal you have seen, your badges, and your SETILive history on your profile page"
          onShow: ->
            $("#nav li.nav_user").addClass("tutorial_select")
            $("#nav li.tutorial_profile").addClass("tutorial_item_selected ")
          onLeave: ->
            $("#nav li.nav_user").removeClass("tutorial_select")
            $("#nav li.tutorial_profile").removeClass("tutorial_item_selected")
          indicatorPos: "top right"
          location: [500,-330]
          speed: 400
        ,
          title: "More Info"
          onShow: ->
            $("#nav li.nav_about").addClass("tutorial_select")
          onLeave: ->
            $("#nav li.nav_about").removeClass("tutorial_select")
          text: "For more info you can check out the about pages to learn about the science and background to SETILive."
          location: [760,-330]
          speed: 400
        ,
          title: "Tutorial Rerun"
          text: "At any time you can also review this tutorial by clicking here."
          onShow: ->
            $("#nav li.nav_classify").addClass("tutorial_select")
            $("#nav li.tutorial_tutorial").addClass("tutorial_item_selected ")
          onLeave: ->
            $("#nav li.nav_classify").removeClass("tutorial_select")
            $("#nav li.tutorial_tutorial").removeClass("tutorial_item_selected")
          location: [660,-330]
          speed: 400
        ,
          title: "Time"
          text: "So that's it, time to get classifying! Be quick, because we only have a short period of time before the telescope moves on to look at new things!"
          location: [530,20]
          indicatorPos: "top right"
          onLeave: ->
            $.getJSON '/seen_tutorial', ->
              window.location = '/classify'
          speed:400
]