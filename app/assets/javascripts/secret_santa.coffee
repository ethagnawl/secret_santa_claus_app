participant_template = """
    <fieldset class='control-group participant'>
        <input class='hidden-input' type='hidden' name='participant[{{timestamp}}]' />
        <input required placeholder='Name*' class='name' type="text" />
        <input required placeholder='Email Address*' class='email-address' type="text" />
        <a href='javascript: void(0);' class='icon icon-remove-sign remove-participant' title='Remove Participant'></a>
    </fieldset>
"""

confirmation_template = """
    <h3>Participants are being notified!</h3>
"""

render_participant_template = ->
    Mustache.render(participant_template, {
        timestamp: (new Date().getMilliseconds() * Math.floor(Math.random()*11))
    })

render_confirmation_template = -> Mustache.render(confirmation_template, {})

is_valid_email_address = (email_address) ->
    /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(email_address)

emails_are_valid = ->
    _.all ($('.email-address').map -> @value), is_valid_email_address

no_inputs_are_empty = (input_class) ->
    !(_.any ($(".#{input_class}").map -> @value or false), (value) -> value is false)

THIS_NAME_SUCKS = ->
    ($ '.participant').each ->
        name = ($ @).find('.name').val().trim()
        email_address = ($ @).find('.email-address').val().trim()
        ($ @).find('.hidden-input').val("#{name}&#{email_address}")

DEFAULT_PARTICIPANT_COUNT = 6
$participants = $('#participants')

$participants
    .on 'click', '.add-participant', ->
        ($ @).closest('form').find('fieldset:last')
            .before(render_participant_template)

    .on 'click', '.remove-participant', ->
        ($ @).closest('fieldset').remove()

    .on 'submit', (e) ->
        e.preventDefault()
        if no_inputs_are_empty('email-address') and no_inputs_are_empty('name') and emails_are_valid()
            THIS_NAME_SUCKS()
            data = ($ @).serialize()
            $.post '/notify-participants', data, (response) ->
                if response is 'true'
                    $participants.hide()
                    ($ '#events_new').html(render_confirmation_template())
                else
                    alert 'uh oh!'
        else
            alert 'Please verify that you\'ve entered valid information for each participant.'

[0..DEFAULT_PARTICIPANT_COUNT].forEach ->
    $participants.find('fieldset:last').before(render_participant_template())
