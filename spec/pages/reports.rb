include Capybara::DSL

module ReportsIndex
  def go_to_new_report_page
    click_on '新しいReport'
  end

  def go_to_show_report_page(title)
    click_on title
  end

  def search_report(q)
    if q[:tag] then fill_in 'タグ', with: q.tag end
    if q[:title] then fill_in 'タイトル', with: q[:title] end
    if q[:user] then select q[:user], from: 'q_user_id_eq' end
    if q[:date_from] then fill_in 'q[updated_at_gteq]', with: q[:date_from] end
    if q[:date_to] then fill_in 'q[updated_at_lteq_end_of_day]', with: q[:date_to] end
    click_on '検索'
  end
end

module ReportsEdit
  def fill_report(d)
    if d[:tag] then fill_in 'タグ', with: d[:tag] end
    if d[:title] then fill_in 'タイトル', with: d[:title] end
    if d[:content] then fill_in '内容', with: d[:content] end
  end

  def insert_img(file)
    attach_file 'image', file
  end

  def attach(files)
    attach_file 'report[attachments][]', files
  end

  def delete_attach(i)
    all('a.btn-warning')[i].click
  end

  def save_report
    click_on '保存'
  end

  def update_report
    click_on '更新'
  end
end

module ReportsShow
  def delete_report
    click_on '削除'
  end

  def go_to_edit_report_page
    click_on '更新'
  end
end
