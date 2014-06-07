$.valHooks['xcalendar'] =
    get: (el)->
        value = $(el).find('.xcalendar').val()
        if not value
            return null
        format = $(el).attr('format')
        moment.utc(value, format).toDate()
 
    set: (el, value)->   
        if _.isEqual(value, [""]) or value == ''
            return
        value = moment(value, 'DD-MM-YYYY')     
        format = $(el).attr('format')
        value = value.format(format)
        #$(el).find('.xcalendar').val(value)
        $(el).find('.xcalendar').attr('value',value)

$.fn.xcalendar = (id)->
    this.each -> 
        this.type = 'xcalendar'
        calendar_pop.insert({id:id, visible:false})
    this

Template.xcalendar.rendered = ->
    $('.container-calendar').xcalendar($(@find('.xbutton')).attr('id'))

Session.set 'xday', moment().toDate()
calendar_pop = new Meteor.Collection null

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

Template.xcalendar.helpers
    objeto: -> {value:moment(), id:'10'}
    setInitial: (value, id)->
        console.log value, typeof value
        if value        
            value = moment(value, "YYYY-MM-DD[T]hh:mm:ss.SSS").format('DD-MM-YYYY')
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
            ret.push {value: ini.format('DD'), date: ini.format('DD-MM-YYYY'), clase: clase}
            ini.add('days', 1)
        ret[week*7...week*7+7]


            