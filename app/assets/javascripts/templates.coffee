$ ->
  $('.js-template-select').on('change', () ->
    return unless $('.js-template-select').val()
    $.getJSON('/reports/' + $('.js-template-select').val() + '.json', (json) ->
      console.log json
      $('#report_tag').val( json.tag.replace(/テンプレート/g, '').replace(/  /g, ' ') )
      $('#title').val( applyVariable(json.title) )
      $('#content').val( applyVariable(json.content) )
    )
  )

  new jBox('Modal',
    attach: $('#templateRule')
    title: 'テンプレートの使い方'
    content: 'タグに「テンプレート」という文字を設定するとテンプレートとして参照できます。<br>「テンプレート タグ１」のようにすると、読み込んだときに「タグ１」がタグに反映されます。<br><br>#{yyyy}, #{mm}, #{dd}で当日の年、月、日、#{me}で自分のユーザー名が入力できます。'
  )

applyVariable = (str) ->
  return str
    .replace(/\#{yyyy}/, (new XDate()).getFullYear())
    .replace(/\#{mm}/, (new XDate()).getMonth())
    .replace(/\#{dd}/, (new XDate()).getDate())
    .replace(/\#{me}/, $('#user_name').text())
