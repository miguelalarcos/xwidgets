Session.set 'xMark', 0
xdata = new Meteor.Collection null

Template.xinteger.helpers
    xMark: -> Session.get 'xMark'
    setInitial: (name, value)->
        xdata.insert({name:name, value:value})
        null
    getValue: (name)->
        xdata.findOne(name:name).value

Template.xinteger.events
    'mousemove .mark': (e,t)->
        Session.set 'xMark', e.offsetX
    'click .mark': (e,t)->
        name = $(e.target).attr('name')
        xdata.update({name: name}, {$set: {value: e.offsetX} })

$.valHooks['xinteger'] =
    get: (el)->
        name = $(el).attr('name')
        xdata.findOne(name:name).value
    set: (el, value)->   
        name = $(el).attr('name')
        xdata.update({name:name}, {$set:{value: value}})

$.fn.xinteger = ->
    this.each -> 
        this.type = 'xinteger'
    this

Template.xinteger.rendered = ->
    $(this.find('.xinteger')).xinteger()
