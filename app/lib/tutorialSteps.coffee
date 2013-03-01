{Step} = require 'zooniverse/lib/controllers/tutorial'

module.exports = [
  new Step
    title: 'Welcome to GeneRun!'
    content:'''
      <p>We need your help to hunt for genetic anomolies in cancers</p>
    '''
    attachment: to: '.points', x:'middle', y: 'middle'

  new Step
    title: 'Data'
    content: '''
      <p>These points represent data scientists have collected about the genes of cancer cells</p>
      
    '''
    attachment: arrowDirection: 'top', to: '.ground', at: y: 'top'

  new Step
    title: 'Data'
    content: '''
      <p>We need you to help us select collections of points that are consistently above or bellow the white line</p>
    '''
    attachment:  to: '.ground, .classifier .help-ball', at: y: 'top'

  new Step
    title: 'Marking'
    content: '''
      <p>When you see  a section such as this one, which is higher in this case, simply click once to mark the start of a region. Then again to mark its end</p>
    '''
    attachment: arrowDirection: 'top', y: 'bottom', to: '.ground', at: y: 'top'

  new Step
    title: 'Marking'
    content: '''
      <p>Thats all there is to it. When your done with a section you can press space bar to move on</p>
   
    '''
    attachment:  y: 'bottom', to: '.ground', at: y: 'top'

  new Step
    title: 'Awards'
    content: '''
      <p>Do lots of data to win medals!</p>
    '''
    attachment:  y: 'bottom', to: '.ground', at: y: 'top'

  new Step
    title: 'Groups'
    content: '''
      <p>Create a group and invite your friends to run with you by clicking your profile on the sign</p>
    '''
    attachment:  y: 'bottom', to: '.ground', at: y: 'top'

  new Step
    title: 'Have fun!'
    content: '''
      <p>We will combine the regions you mark with other runners and together we can help scientists better understand cancer</p>
      <p>Thanks for your help!</p>
    '''
    attachment:{y: 'bottom', to: '.ground', at: y: 'top'}
    onLeave: ->  localStorage['doneTutorial']='true'


]