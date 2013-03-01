Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Subject = require 'models/subject'
User = require 'zooniverse/lib/models/user'

class Classification extends Spine.Model
  @configure 'Classification', 'subject_id', 'annotations', 'workflow_id'
  
  constructor: ->
    super
    @annotations ||= []
    @activeAnnotations ||=[]
    

  currentAnnotations:=>
    temp = @activeAnnotations
    temp.push  @currentAnnotation
    temp

  archiveAnnotations :->
    for annotation in @activeAnnotations
      @annotations.push annotation
    @activeAnnotations=[]
  
  subject: =>
    Subject.find @subject_id
  
  annotateStart :(startPos)=>
    @currentAnnotation = {start: startPos}

  annotateEnd :(endPos)=>
    @currentAnnotation.endPos = endPos

    
  doneAnnotation:=>
    if @currentAnnotation?
      @activeAnnotations.push @currentAnnotation
    @currentAnnotation=[]

  url: =>
    "/projects/gene_runner/workflows/#{@workflow_id}/classifications"
  
  toJSON: =>
    json =
      classification:
        subject_ids: [@subject_id]
        favorite: false
    
    json.classification = $.extend json.classification, super
    json
  
  send: =>
    User.current?.project.classification_count+=1
    User.current?.save()
    User.current?.trigger("updateProfile")
    Classification.trigger 'classified'
    Api.post @url(), @toJSON()

module.exports = Classification