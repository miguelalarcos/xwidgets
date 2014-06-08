Package.describe({
    summary: "A set of useful widgets for display and enter data. Play nicely with AutoForm."
});

Package.on_use(function (api) {
    api.use(['jquery', 'coffeescript', 'underscore', 'moment', 'templating', 'session'], 'client');
    api.use('coffeescript', 'server');

    api.add_files(['style.css', 'xboolean.html', 'xboolean.coffee', 'xautocomple.html', 'xcalendar.html', 'xautocomplete.coffee', 'xcalendar.coffee'], 'client');
    //api.add_files('xautocomple.html', 'client');
});