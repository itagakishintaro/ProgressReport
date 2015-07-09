userId = 0
lastNoticeWatchTime = 0

$ -> 
	userId = $('#user_id').text()
	setNotice() # トップ画面表示の際にNoticeマークを変化させる
	setNoticeMark()
	$('#notice').on('click', () -> 
		setNotice()
		upsertLastNoticeWatchTime( userId, new XDate().toString() )
		setNoticeMark()
	)

# 通知の設定
setNotice = ->
	$('#notice-body').empty()
	getLastNoticeWatchTime()
	setXForUser('comments', userId)
	setXForUser('progresses', userId)
	sortNoticeBody()

setNoticeMark = ->
	getLastNoticeWatchTime()
	latestNotice = $('#notice-body div:first-child').data('at')
	if latestNotice > lastNoticeWatchTime
		$('#notice').removeClass('lightgray-text')
		$('#notice').addClass('yellow-text')
	else
		$('#notice').addClass('lightgray-text')
		$('#notice').removeClass('yellow-text')

sortNoticeBody = ->
	sorted = $('#notice-body').children().sort( (a, b) -> return $(b).data('at') - $(a).data('at') )
	console.log sorted
	if sorted.length > 0
		$('#notice-body').html(sorted)
	else
		$('#notice-body').html('通知はありません。')

setXForUser = (x, user) ->
	$.ajax(
		url: "/#{x}/for_user/#{user}"
		dataType: 'json'
		async: false
	).done( (json) ->
		report_id_list = getReportIdList(json)
		report_id_list.forEach( (report_id, i) ->
			at = getAt(json, report_id)
			watched = ''
			watched = ' watched' if at < lastNoticeWatchTime
			open = '<div class="notice-row' + watched + '" data-at="' + at + '"><a href="/reports/' + report_id + '">'
			
			body = ''
			names = getNames(json, report_id)
			names.forEach( (v, i) ->
				body += "#{v}さん "
			)

			action = 'コメント'
			action = '成長したね' if x == 'progresses'
			close = "があなたのレポートに#{action}しました。</a></div>"
			
			$('#notice-body').append(open + body + close)
		)
	)

# ヘルパー
getReportIdList = (json) ->
	json.map( (v, i) ->
		return v.report_id # report_idだけの配列にして
	).filter( (x, i, self) ->
        return self.indexOf(x) == i # 重複を排除
    )

getAt = (json, report_id) ->
	Math.max.apply(null, json.filter( (v) ->
		return v.report_id == report_id
	).map( (o) ->
		return new XDate(o.updated_at).getTime()
	))

getNames = (json, report_id) ->
	names = []
	json.filter( (v) ->
		return v.report_id == report_id # report_idで絞って
	).map( (v, i) ->
		return v.user_name # user_nameだけの配列にして
	).filter( (x, i, self) ->
        return self.indexOf(x) == i # 重複を排除して
    ).forEach( (v, i) ->
		names.push(v) # 名前を追記する
	)
	return names

# 通知確認時刻の更新と取得
upsertLastNoticeWatchTime = (userId, watchedAt) ->
	data = {user_id: userId, watched_at: watchedAt}
	console.log data
	$.post(
		'/notices/upsert',
		data,
		(d) ->
			lastNoticeWatchTime = watchedAt
	)

getLastNoticeWatchTime = ->
	$.ajax(
		url: "/notices/#{userId}"
		dataType: 'json'
		async: false
	).done( (json) ->
		lastNoticeWatchTime = new XDate(json.watched_at).getTime() if json
	)

