Session.set 'xMark', 0
xdata = new Meteor.Collection null

Template.xpercentage.helpers
    xMark: -> Session.get 'xMark'
    setInitial: (name, value)->
        el = $('div.xwidget[name='+name+']')
        el.val(value)
        null
    getValue: (name)->
        item = xdata.findOne(name:name)
        if item then item.value else null
    getName: ->
        if this.formContext
            prefix = this.formContext._af.formId
        else
            prefix = ''
        prefix + '#' + this.name

Template.xpercentage.events
    'mousemove .mark': (e,t)->
        Session.set 'xMark', e.offsetX
    'click .mark': (e,t)->
        $(t.find('.xpercentage')).val(e.offsetX)

$.valHooks['xpercentage'] =
    get: (el)->
        name = $(el).attr('name')
        xdata.findOne(name:name).value
    set: (el, value)->   
        name = $(el).attr('name')
        if not xdata.findOne(name:name)
            xdata.insert({name:name, value:value})
        else
            xdata.update({name:name}, {$set:{value: value}}) 

$.fn.xpercentage = ->
    this.each -> 
        this.type = 'xpercentage'
    this

Template.xpercentage.rendered = ->
    $(this.find('.xpercentage')).xpercentage()
