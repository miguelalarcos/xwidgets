describe "xcalendar", ->
    it "set moment", ->
        date = moment.utc()
        $('div[data-schema-key=date]').val(date)   
        Meteor.setTimeout ->  
            value = moment($('div[data-schema-key=date]').val())        
            chai.assert.equal date.isSame(value, 'minute'), true

    it "set Date", ->
        date = moment.utc().toDate()
        $('div[data-schema-key=date]').val(date)   
        Meteor.setTimeout ->    
            value = $('div[data-schema-key=date]').val()
            value=moment(value)
            chai.assert.equal moment(date).isSame(value, 'minute'), true
    
    it 'insert date', ->
        items2 = window.items2
        date = moment.utc()
        $('div[data-schema-key=date]').val(date)  
        Meteor.setTimeout ->     
            value = $('div[data-schema-key=date]').val()
            
            id = items2.insert(date:value)
            value = items2.findOne(id).date
            value = moment(value)
            items2.remove id
            chai.assert.equal date.isSame(value, 'minute'), true

    it 'insert date2', ->
        items2 = window.items2
        date = moment.utc().toDate()
        $('div[data-schema-key=date]').val(date) 
        Meteor.setTimeout ->      
            value = $('div[data-schema-key=date]').val()
            
            id = items2.insert(date:value)
            value = items2.findOne(id).date
            value = moment(value)
            items2.remove id
            chai.assert.equal moment(date).isSame(value, 'minute'), true