describe "xpercentage", ->
    it "set value", ->
        value = 50
        $('div[data-schema-key=integer]').val(value)   
        Meteor.flush()  
        value_after = $('div[data-schema-key=integer]').val()     
        chai.assert.equal value, value_after