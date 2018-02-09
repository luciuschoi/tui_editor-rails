# 레일스 프로젝트에 TOAST UI Editor 설치하기(2)

[매뉴얼](https://github.com/nhnent/tui.editor/wiki/Getting-Started-Korean)에 따르면 **tui-editor** 패키지는 **bower**로 설치할 것을 권하고 있다. 

레일스 프로젝트에서는 **bower-rails** 젬을 번들 인스톨하면 자동으로 **bower**를 사용할 수 있는 환경을 셋팅해 준다.

**레일스 프로젝트에 TOAST UI Editor 설치하기(1)** 를 참고하면 이에 대한 설명을 자세히 볼 수 있다. 이 글에서는 **bower**로 패키지를 설치하는 과정을 젬으로 묵어 버린 **tui_edito-rails** 라는 젬을 사용하여 **TOAST UI Editor**를 설치하는 방법을 소개한다.

## 1. 젬 추가

먼저 **Gemfile**에 다음과 같이 추가하고, 

```ruby
gem "tui_editor-rails", "~> 1.0.2.0"
```

번들 인스톨한다.

```shell
$ bundle install
```

## 2. 자바스크립트 추가하기

**app/assets/javascripts/application.js**  파일을 열고 다음과 같이 작성한다.

```javascript
//= require jquery/dist/jquery
//= require tui-code-snippet/dist/tui-code-snippet
//= require markdown-it/dist/markdown-it
//= require to-mark/dist/to-mark
//= require codemirror/lib/codemirror
//= require highlightjs/highlight.pack
//= require squire-rte/build/squire
//= require tui-editor/dist/tui-editor-Editor.min
//= require activestorage
//= require turbolinks
//= require_tree .
```

## 3. 스타일시트 추가하기

app/assets/stylesheets/application.scss 파일을 열고 다음과 같이 추가한다.

```scss
@import 'codemirror/lib/codemirror';
@import 'highlightjs/styles/github';
@import 'tui-editor/dist/tui-editor';
@import 'tui-editor/dist/tui-editor-contents';
```

## 4. 에디터 생성하기

마지막으로 원한는 뷰 파일을 열과 다음과 같이 작성한다.

```html
<div id="editSection"></div>
<script>
    $('#editSection').tuiEditor({
        initialEditType: 'markdown',
        previewStyle: 'vertical',
        height: 400
    });
</script>
```

![](assets/screen_capture.png)