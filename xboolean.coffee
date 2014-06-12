# local collection to save the data per field name (the concatenation of idForm and name field)

xdata = new Meteor.Collection null

$.valHooks['xboolean'] =
    get: (el)->
        name = $(el).attr('name')
        item = xdata.findOne(name:name)
        if item
            item.value
        else
            undefined
    set: (el, value)->   
        name = $(el).attr('name')
        if not xdata.findOne(name:name)
            xdata.insert({name:name, value:value})
        else
            xdata.update({name:name}, {$set:{value: value}}) 


$.fn.xboolean = ->
    this.each -> 
        this.type = 'xboolean'
    this

Template.xboolean.rendered = ->
    $(this.find('.xboolean')).xboolean()

Template.xboolean.events
    'click circle': (e,t) ->
        name = $(e.target).attr('name')
        
        item = xdata.findOne(name:name)
        if item
            $(t.find('.xboolean')).val(not item.value)
        else
            $(t.find('.xboolean')).val(false)

Template.xboolean.helpers
    setInitial: (name, value)->
        if value == 'true' then value = true else value = false
        el = $('div.xwidget[name='+name+']')
        el.val(value)
        null

    getColor: (name) ->
        item = xdata.findOne(name:name)
        if item
            if item.value then 'green' else 'red'
        else
            'black'
    getName: ->
        if this.formContext
            prefix = this.formContext._af.formId
        else
            prefix = ''
        prefix + '#' + this.name

