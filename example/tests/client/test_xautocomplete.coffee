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