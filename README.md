xwidgets
========

A set of useful widgets for display and enter data. Plays nicely with AutoForm, but I'm thinking as well in SCADA like widgets.

Important: It's in fase beta. 

See the example.

To run with tests just ```export METEOR_MOCHA_TEST_DIRS=tests``` and then ```meteor```.

Any help is welcomed. Tell me you want to and I will make you a contributor.

- o - O - o -

Let's see a simple guide on how to make a *xwidget*. In this case the *xboolean*, wich consist in a svg circle with color red or green.
To use the widget just:

```html
{{> xboolean name="isBig" value=this.isBig}}
```

or inside AutoForm:

```html
...
{{> afFieldInput name='isBig' template='circle'}}
...

<template name='afCheckbox_circle'>
    {{> xboolean name=this.name value=this.value}}
</template>


<template name="xboolean">  <!--prefix=x; I want prefix to be xw- xw_ and xwCapital  -->
  <div class=xboolean name="{{this.name}}" data-schema-key="{{this.name}}"> <!--class the name of the template but with the prefix convention: xw- -->
    {{setInitial this.name this.value}}  <!-- see below -->
    <svg height="10" width="10">
        <circle name="{{this.name}}" cx="5" cy="5" r="5" fill="{{getColor this.name}}" /> <!-- set name here as well for easy access to this important property. See that for the color we use a helper, instead of setting the attribute fill from code. I think this is the Meteor way -->
    </svg>
  </div>
</template>
```

```coffee
Template.xboolean.helpers
    setInitial: (name, value)->
        if value == 'true' or value is true then value = true else value = false
        el = $('div[name='+name+']')
        el.val(value) # and, how do we set to a div? See below
        null # return null so nothing is printed in the template where the *{{setInitial ...}}* is
```

jquery stuff: (I don't understand this as well I'd like to :)

```coffee
$.valHooks['xboolean'] =
    get: (el)-> # *el* is the main div
        name = $(el).attr('name')
        xdata.findOne(name:name).value # xdata is a local collection where we save an item per widget instance. The instance is recognized by the name
    set: (el, value)->   
        name = $(el).attr('name')
        if not xdata.findOne(name:name) # the first time the widget is created we must do an insert
            xdata.insert({name:name, value:value})
        else
            xdata.update({name:name}, {$set:{value: value}}) # next times we must do updates


$.fn.xboolean = ->
    this.each -> 
        this.type = 'xboolean'
    this

Template.xboolean.rendered = ->
    $(this.find('.xboolean')).xboolean() # we do the association at the main div
```

What is missing:

```coffee
xdata = new Meteor.Collection null # we pass null to ensure this is a local collection

Template.xboolean.helpers
    ...

    getColor: (name) ->
        item = xdata.findOne(name:name)
        if item
            if item.value then 'green' else 'red'
        else
            'black'
```

At the time of this writting there's a problem with the name we pass to the template. Imagine there are two forms and there's a name, the same name, in each form (and the same type). There's no way to discriminate. One solution is to concatenate the idForm and the name. Other solution is to pass another attribute called *xname* only when there's a collision.