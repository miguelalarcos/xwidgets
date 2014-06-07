items = @items

if items.find().count() == 0
    for name in ['Dennet', 'Darwin', 'Dawkins']
        items.insert name: name

Meteor.methods
    items: (query)->
        items.find(name: {$regex: '^.*'+query+'.*$'}).fetch()
