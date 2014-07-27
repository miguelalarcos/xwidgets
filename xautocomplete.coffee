Session.set 'xquery', null
local_items = new Meteor.Collection null
@local_tags = local_tags = new Meteor.Collection null
xdata = new Meteor.Collection null

index = -1
current_input = null

Template.xautocomplete.helpers
    getName: ->
        if this.formContext
            prefix = this.formContext._af.formId
        else
            prefix = ''
        prefix + '#' + this.name
    getValue: (name) ->
        item = xdata.findOne(name:name)
        if item 
            item.value 
        else 
            null
    setInitial: (name, value)-> 
        el = $('div.xwidget[name='+name+']')
        el.val(value) # set the value on the container
        null        
    tags: (tag) -> local_tags.find tag:tag 
    items: (call, name) -> # the items that will be shown in the popover
        query = Session.get('xquery')
        if name == current_input                    
            if query != ''
                Meteor.call call, query, (error, result)->
                    local_items.remove({})  
                    for item, i in (result or [])
                        local_items.insert({name: item.name, index: i, remote_id: item._id})
            local_items.find({})
        else
            null

Template.xautocomplete.events
    'click .xitem':(e,t)->
        el = t.find('.xautocomplete')
        name = $(t.find('.xautocomplete')).attr('name')
        value = $(e.target).html() # why html?
        xdata.update({name:name}, {$set: {value:value}})
        index = $(e.target).attr('index')        
        local_items.update({},{$set:{selected: ''}})
        local_items.update({index: parseInt(index)}, {$set:{selected: 'selected'}})
        
        e = jQuery.Event("keyup") # in tag mode when we click on an item, then we produce an enter so the tag is accepted
        e.keyCode = 13
        $(el).trigger(e)

    'keyup .xautocomplete': (e,t)->
        if e.keyCode == 38
            local_items.update({index:index}, {$set:{selected: ''}})
            if index == -1 then index = -1 else index -= 1
            local_items.update({index:index}, {$set:{selected: 'selected'}})
        else if e.keyCode == 40
            local_items.update({index:index}, {$set:{selected: ''}})
            count = local_items.find({}).count() - 1
            if index == count then index = 0 else index += 1
            local_items.update({index:index}, {$set:{selected: 'selected'}})
        else if e.keyCode == 13
            $(e.target).parent().find('.popover').focus()
            if t.data.tag # tag mode
                selected = local_items.findOne selected: 'selected'
                if selected
                    value = selected.name
                else
                    value = $(e.target).val()
                item = local_items.findOne({name:value})
                # we don't add an item if it exists yet; we admit a value that is not an item if strict is false
                if not local_tags.findOne({tag: t.data.tag, value:value}) and (item or t.data.strict == 'false')
                    if item then id = item.remote_id else id = null
                    local_tags.insert({tag: t.data.tag, value:value, remote_id: id}) 
            else
                selected = local_items.findOne selected: 'selected'
                if selected
                    name = $(e.target).attr('name')
                    xdata.update({name:name}, {$set: {value:selected.name}})
                    $(e.target).attr('_id', selected.remote_id)             
            # close popover
            local_items.remove({})
            Session.set('xquery','')
            index = -1
        else # normal keypress. If the text is like an item, we set the _id as the remote _id
            Session.set 'xquery', $(e.target).val()
            current_input = $(e.target).attr('name')
            item = local_items.findOne({name: $(e.target).val()})
            if item
                $(e.target).attr('_id', item.remote_id)
            else
                $(e.target).attr('_id', 'null')
    'click .xclose':(e,t)->
        val = $(e.target).attr('value')
        local_tags.remove({tag: t.data.tag, value:val})

    'blur .popover': (e,t)->
        local_items.remove({})
        Session.set('xquery','')


$.valHooks['xautocomplete'] = 
    get : (el)->
        tag = $(el).attr('tag')
        if tag
            if $(el).attr('references')                
                (x.remote_id for x in local_tags.find(tag: tag).fetch())
            else
                (x.value for x in local_tags.find(tag: tag).fetch())
        else
            if $(el).attr('references')
                $(el).find('.xautocomplete').attr('_id')
            else
                if $(el).attr('strict') == 'true' and $(el).find('.xautocomplete').attr('_id') == 'null'
                    return null
                $(el).find('.xautocomplete').val()                

    set : (el, value)->
        if _.isEqual(value, [""])
            value = []
        tag=$(el).attr('tag')
        references = $(el).attr('references')
        if references
            a = references.split('.')
            collection = a[0]
            collection = window[collection]
            toDisplay = a[1]
        if tag
            local_tags.remove tag:tag
            for v in value
                _id = null
                if references
                    item = collection.findOne(v)
                    v = item[toDisplay]
                    _id = item._id
                local_tags.insert tag:tag, value: v, remote_id: _id
        else
            if references
                item = collection.findOne(_id: value)
                if item
                    value = item[toDisplay]
                    _id = item._id
                $(el).find('.xautocomplete').attr('_id', _id)
            #$(el).find('.xautocomplete').val(value)
            name = $(el).attr('name')
            xdata.remove({name:name})
            xdata.insert({name:name, value:value})

$.fn.xautocomplete = ->
    this.each -> this.type = 'xautocomplete'
    this
     

Template.xautocomplete.rendered = -> 
    $(this.find('.xautocomplete-tag')).xautocomplete()


