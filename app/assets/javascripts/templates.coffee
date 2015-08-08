$ ->
  $('.js-template-select').on('change', () ->
    $.getJSON('/reports/' + $('.js-template-select').val() + '.json', (json) ->
      console.log json
      $('#report_tag').val(json.tag)
      $('#title').val(json.title)
      $('#content').val(json.content)
    )
  )
