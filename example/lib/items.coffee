@items = new Meteor.Collection "Items"

@items2 = new Meteor.Collection "Items2",
    schema:
        field1:
            type: [String]
            optional: true
        field2:
            type: String
            optional: true
        field3:
            type: [String]
            optional: true
        field4:
            type: String
            optional: true
        field5:
            type: [String]
            optional: true
        field6:
            type: String
            optional: true
        date:
            type: Date 
            optional: true
        date2: 
            type: Date
            optional: true