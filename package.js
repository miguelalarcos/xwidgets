Package.describe({
    summary: "A set of useful widgets for display and enter data. Play nicely with AutoForm."
});

Package.on_use(function (api) {
    api.use(['coffeescript', 'underscore', 'moment'], 'client');

    api.add_files(['style.css', 'xautocomple.html', 'xautocomplete.coffee', 'xcalendar.html', 'xcalendar.coffee'], 'client');
    //api.add_files('xautocomple.html', 'client');
});