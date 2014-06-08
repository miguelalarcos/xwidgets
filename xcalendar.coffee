Session.set 'xday', moment().toDate()
calendar_pop = new Meteor.Collection null

$.valHooks['xcalendar'] =
    get: (el)->
        value = $(el).find('.xcalendar').val()
        if not value
            return null
        format = $(el).attr('format')
        moment.utc(value, format).toDate()
 
    set: (el, value)->   
        if _.isEqual(value, [""]) or value == '' # don't know why happens
            $(el).find('.xcalendar').attr('value', '')    
            return
        if _.isString(value)
            value = moment(value, "YYYY-MM-DD[T]HH:mm:ss.SSS[Z]")
        else if _.isDate(value)
            value = moment(value)

        format = $(el).attr('format')
        value = value.format(format)
        $(el).find('.xcalendar').attr('value',value)

$.fn.xcalendar = (id)->
    this.each -> 
        this.type = 'xcalendar'
        calendar_pop.insert({id:id, visible:false})
    this

Template.xcalendar.rendered = ->
    $('.container-calendar').xcalendar($(@find('.xbutton')).attr('id'))

Template.xcalendar.events
    'click .minus-month': (e,t)->
        Session.set('xday', moment(Session.get('xday')).add('months', -1).toDate())
    'click .plus-month': (e,t)->
        Session.set('xday', moment(Session.get('xday')).add('months', 1).toDate())
    'click .calendar-day': (e,t)->
        el=t.find('.container-calendar')
        $(el).val($(e.target).attr('date'))
    'click .xbutton': (e,t)->
        id=$(e.target).attr('id')
        visible = calendar_pop.findOne(id:id).visible
        calendar_pop.update({id:id}, {$set: {visible: not visible}})
    'click .set-hour': (e,t)->
        el=t.find('.container-calendar')
        hour = $(t.find('.xhour')).val()
        date = moment($(el).val()).startOf('Day').format('YYYY-MM-DD')
        $(el).val(date+' '+hour)

Template.xcalendar.helpers
    setInitial: (value, id)->
        el = $('#'+id).parent()
        el.val(value) # set the value on the container
        null 

    visible: (id)-> 
        item=calendar_pop.findOne(id:id)
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


            