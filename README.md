# github-search-user

<h1>課題コード</h1>

<h2>使用ツール / ライブラリ</h2>
<ul>
  <li>
    CocoaPods
  </li>
  <ul>
    <li>
      Alamofire
    </li>
  <li>
      DZNEmptyDataSet
  </li>
    </ul>
</ul>
  
<code>
  pod install
</code>
  を行なってご確認下さい。
  
<h2>工夫した点</h2>
  初期表示で何もデータがないと不自然なので<br>
  初期表示または検索ワードがない場合は<br>
  <code>
    https://api.github.com/users
  </code><br>
  上記APIにて全ユーザーから情報を取得しています。
  
  
  検索ワードが存在する場合は、<br>
  <code>
    https://api.github.com/search/users
  </code><br>
  より任意の情報を取得するようにしました。
  
  その際、結果が表示されるまでloading画面が表示されるようにしました。
  
  <hr>
  
  検索結果が存在しない場合は、<br>
  ユーザーが不快に思わないために
  メッセージと画像（柴犬）が表示されるよう<br>
  <code>
    DZNEmptyDataSet
  </code><br>
  上記ライブラリを使用し実装しました。
  
  
