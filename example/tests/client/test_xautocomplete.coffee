describe "xautocomplete", ->
    it "set referential array", ->
        items = window.items
        id1 = items.findOne(name: 'Darwin')._id
        id2 = items.findOne(name: 'Dennet')._id
        $('div[data-schema-key=field1]').val([id1, id2])     
        ids = $('div[data-schema-key=field1]').val()
        chai.assert.equal _.isEqual([id1, id2], ids), true

    it "set referential", ->
        items = window.items
        id = items.findOne(name: 'Darwin')._id
        $('div[data-schema-key=field2]').val(id)     
        id2 = $('div[data-schema-key=field2]').val()
        chai.assert.equal id, id2

    it "set array no strict", ->
        $('div[data-schema-key=field3]').val(['hello', 'world'])     
        arr = $('div[data-schema-key=field3]').val()
        chai.assert.equal _.isEqual(['hello', 'world'], arr), true

    it "set no strict", ->
        $('div[data-schema-key=field4]').val('insert coin')  
        Meteor.setTimeout ->   
            value = $('div[data-schema-key=field4]').val()
            chai.assert.equal 'insert coin', value

    it "set array strict", ->
        $('div[data-schema-key=field5]').val(['Darwin', 'Dennet'])     
        arr = $('div[data-schema-key=field5]').val()
        chai.assert.equal _.isEqual(['Darwin', 'Dennet'], arr), true

    it "set strict", ->
        $('div[data-schema-key=field6]').val('Darwin')   
        Meteor.setTimeout ->  
            value = $('div[data-schema-key=field6]').val()
            chai.assert.equal 'Darwin', value