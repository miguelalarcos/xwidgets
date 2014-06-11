# local collection to save the data per field name
# issue: must concatenate the idForm and field name
# to permit several fields with the same name
xdata = new Meteor.Collection null

$.valHooks['xboolean'] =
    get: (el)->
        name = $(el).attr('name')
        xdata.findOne(name:name).value
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

# we make the widget on svg element
# so the svg must have the attr data-schema-key
# to work with AutoForm
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
        el = $('div[name='+name+']')
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


UI.registerHelper 'includeFormContext', ->
    context = actual_context = arguments[0]
    i = 1
    while context and not context._af
        context = arguments[i]
        i += 1

    actual_context.formContext = context
    actual_context

