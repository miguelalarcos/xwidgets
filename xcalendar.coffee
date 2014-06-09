Session.set 'xday', moment.utc().toDate()
Session.set 'time-hour', moment().hour()
Session.set 'time-minute', moment().minute()

calendar_pop = new Meteor.Collection null
xdata = new Meteor.Collection null

$.valHooks['xcalendar'] =
    get: (el)->
        value = $(el).find('.xcalendar').val()
        if not value
            return null
        format = $(el).attr('format')
        moment(value, format).utc().toDate()
 
    set: (el, value)->   
        name = $(el).attr('data-schema-key')
        if _.isEqual(value, [""]) or value == '' # don't know why happens
            #$(el).find('.xcalendar').attr('value', '')  
            #xdata.remove(name:name)        
            #xdata.insert(name:name, value:'')
            xdata.update({name: name}, {$set:{value: ''}})
            return
        if _.isString(value)
            value = moment(value, "YYYY-MM-DD[T]HH:mm:ss.SSS[Z]")
        else if _.isDate(value)
            value = moment(value)
        else
            value = value.local()

        format = $(el).attr('format')
        value = value.format(format)
        
        #xdata.remove(name:name)        
        #xdata.insert(name:name, value:value)
        xdata.update({name: name}, {$set:{value: value}})
        

$.fn.xcalendar = (name)->
    this.each -> 
        this.type = 'xcalendar'
        #calendar_pop.insert({name:name, visible:false})
    this

Template.xcalendar.rendered = -> 
    #$(this.find('.container-calendar')).xcalendar($(@find('.xbutton')).attr('name'))
    $(this.find('.container-calendar')).xcalendar()

Template.xcalendar.events
    'click .minus-month': (e,t)->
        Session.set('xday', moment(Session.get('xday')).add('months', -1).toDate())
    'click .plus-month': (e,t)->
        Session.set('xday', moment(Session.get('xday')).add('months', 1).toDate())
    'click .calendar-day': (e,t)->
        el=t.find('.container-calendar')
        date = moment($(e.target).attr('date'))
        date.hour(Session.get('time-hour')).minute(Session.get('time-minute'))
        $(el).val(date)
    'click .xbutton': (e,t)->
        name=$(e.target).attr('name')
        visible = calendar_pop.findOne(name:name).visible
        calendar_pop.update({name:name}, {$set: {visible: not visible}})
    'click .minus-hour': (e,t)->
        hour = Session.get 'time-hour'
        hour = if hour==0 then 0 else hour-1
        Session.set('time-hour', hour)
        el=t.find('.container-calendar')
        #date = moment($(el).val()).startOf('Day').format('YYYY-MM-DD')
        #$(el).val(date+' '+hour)
        date = moment($(el).val()).hour(hour)
        $(el).val(date)
    'click .plus-hour': (e,t)->
        hour = Session.get 'time-hour'
        hour = if hour==23 then 23 else hour+1
        Session.set('time-hour', hour)    
        el=t.find('.container-calendar')
        #date = moment($(el).val()).startOf('Day').format('YYYY-MM-DD')
        date = moment($(el).val()).hour(hour)
        $(el).val(date)
    'click .minus-minute': (e,t)->
        hour = Session.get 'time-hour'
        minute = Session.get 'time-minute'
        minute = if minute == 0 then 0 else minute-1
        Session.set('time-minute', minute)
        el=t.find('.container-calendar')
        date = moment($(el).val()).hour(hour).minute(minute)
        $(el).val(date)
    'click .plus-minute': (e,t)->
        hour = Session.get 'time-hour'
        minute = Session.get 'time-minute'
        minute = if minute == 59 then 59 else minute+1
        Session.set('time-minute', minute)
        el=t.find('.container-calendar')
        date = moment($(el).val()).hour(hour).minute(minute)
        $(el).val(date)
        

Template.xcalendar.helpers
    getHour: -> Session.get 'time-hour'
    getMinute: -> Session.get 'time-minute'
    getValue: (name) ->
        item = xdata.findOne(name:name)
        if item
            item.value
        else
            null
    setInitial: (value, name)->
        calendar_pop.insert({name:name, visible:false})
        xdata.insert({name:name, value:value})
        el = $('[name='+name+']').parent()
        el.val(value) # set the value on the container
        null 

    visible: (name)-> 
        item=calendar_pop.findOne(name:name)
        if not item or not item.visible
            'invisible'
    week: -> (i for i in [0...6])
    day: (week) -> 
        ret = []
        day=Session.get 'xday'
        day=moment(day)
        ini_month = day.clone().startOf('Month')
        ini = day.clone().startOf('Month').add('days', -ini_month.day())
        end_month = day.clone().endOf('Month').startOf('Day')
        end = day.clone().endOf('Month').add('days', 7-end_month.day()).startOf('Day')

        while not ini.isSame(end)
            if ini_month.format('MM') == ini.format('MM')
                clase = 'bold'
            else
                clase = ''
            ret.push {value: ini.format('DD'), date: ini.format('YYYY-MM-DD'), clase: clase}
            ini.add('days', 1)
        ret[week*7...week*7+7]


            