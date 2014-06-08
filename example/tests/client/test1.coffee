describe "test1", ->
    it "some test", ->
        date = moment.utc()
        $('div[data-schema-key=date]').val(date)     
        value = moment($('div[data-schema-key=date]').val())        
        chai.assert.equal date.isSame(value, 'minute'), true

    it 'other test', ->
        items2 = window.items2
        date = moment.utc()
        $('div[data-schema-key=date]').val(date)     
        value = $('div[data-schema-key=date]').val()
        
        id = items2.insert(date:value)
        value = items2.findOne(id).date
        value = moment(value)
        items2.remove id
        chai.assert.equal date.isSame(value, 'minute'), true