describe "xboolean", ->
    it "set value true", ->
        value = true
        $('div[data-schema-key=boolean]').val(value)   
        Meteor.flush()
        value_after = $('div[data-schema-key=boolean]').val()    
        chai.assert.isTrue value_after

    it "set value false", ->
        value = false
        $('div[data-schema-key=boolean]').val(value)   
        Meteor.flush()
        value_after = $('div[data-schema-key=boolean]').val()     
        chai.assert.isFalse value_after            