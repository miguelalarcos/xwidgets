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
        val = xdata.findOne(name:name).value
        xdata.update({name:name}, {$set:{value: not val}})

Template.xboolean.helpers
    setInitial: (name, value)->
        if value == 'true' then value = true else value = false
        xdata.insert({name:name, value:value})
        null
    getColor: (name) ->
        val = xdata.findOne(name:name).value
        if val then 'green' else 'red'