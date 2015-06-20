$ -> 
    $('#tagcloud').empty()
    $.getJSON('/reports/tagcount', (json) ->
        $('#tagcloud').jQCloud( json )
    )