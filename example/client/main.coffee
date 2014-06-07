Session.set 'idDoc', null
items2 = @items2
Template.form.helpers
    type: -> if Session.get('idDoc') is null then 'insert' else 'update'
    doc: -> items2.findOne Session.get('idDoc')
    items: -> items2.find()

Template.form.events
    'click .editable': (e,t)->
        _id = $(e.target).attr('_id')
        Session.set 'idDoc', _id  