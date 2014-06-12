UI.registerHelper 'includeFormContext', ->
    context = actual_context = arguments[0]
    i = 1
    while context and not context._af
        context = arguments[i]
        i += 1

    actual_context.formContext = context
    actual_context

