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

In tui-editor, two classes are included for editor and, more lighter, viewer in accoding to tui-editor docs:
- ToastUIEditor
- ToastUIEditorViewer

But, you should not require editor and viewer classes synchronously for tui-editor; editor or viewer class per one webpage.
That is important. 

So, codes to implement tui-editor in rails project are not only verbose but also smells monkey. But with my poor javascript coding tech, it works well in assocation with form-associated tag element(textarea).

First of all, I needed a controller-specific namespacing for javascript codes to prevent javascript errors in other web pages not including tui-editor. In layout template, I added class style to body tag as follows:

```html
<body class="<%= controller_name %> <%= action_name %>">
```

Next, I added at the top of `_form.html.erb` partial to use tui editor as follows:

```html
<script src="/assets/tui-editor/dist/tui-editor-Editor.min"></script>
<script src="/assets/tui-editor/dist/tui-editor-extScrollSync.min"></script>
```

And, I added at the top of `show.html.erb` view template to use tui viewer as follows:

```html
<script src="/assets/tui-editor/dist/tui-editor-Viewer.min"></script>
```

To implement javascript codes in the special scope, I needed additional javascript codes. That is 
[ORGANIZING JAVASCRIPT IN RAILS APPLICATION WITH TURBOLINKS](http://brandonhilkert.com/blog/organizing-javascript-in-rails-application-with-turbolinks/)

To implement this logic, I referred to this blog post and finally wrote codes as follows:

```coffeescript
$(document).on "turbolinks:load", ->
  return unless $(".home.index, .posts.new, .posts.edit").length > 0
  tui_editor = new App.TuiEditor $("[data-editor='tui-editor']")
  tui_editor.render()
  tui_editor.form.submit (event) ->
    tui_editor.el.text $("##{tui_editor.el[0].id}-editor").tuiEditor 'getValue'  
$(document).on "turbolinks:load", ->
  return unless $(".posts.show").length > 0
  tui_viewer = new App.TuiViewer $("[data-viewer='tui-viewer']")
  tui_viewer.render()  
```

In this code snippets, specific class selecting is critically important as follows:

```coffeescript
•••
return unless $(".home.index, .posts.new, .posts.edit").length > 0
•••
```

That is, we can scope javascript implementation to specific controllers and, more over, to specific actions.

So I needed two more classes for editor and viewer.

in **app.tui_editor.coffee**:

```coffeescript
class App.TuiEditor
  constructor: (@el) ->
    @el.hide().after "<div id='#{@el[0].id}-editor'></div>"
    @form = @el.closest('form')
    # console.log @form

  render: ->
    $("##{@el[0].id}-editor").tuiEditor
      initialEditType: 'markdown'
      initialValue: @el.text()
      viewer: false
      previewStyle: 'vertical'
      height: 500,       
      exts: ['scrollSync'] 
```

in **app.tui_viewer.coffee**:

```coffeescript
class App.TuiViewer
  constructor: (@el) ->
    @el.hide().after "<div id='#{@el[0].id}-viewer'></div>"

  render: ->
    $("##{@el[0].id}-viewer").tuiEditor
      viewer: true
      initialValue: @el.text()
      height: 500
```

Finally, I needed a global scope to implement javascript codes in all pages.

```coffeescript
window.App ||= {}

App.init = ->
  # you can write code to implement in all pages.

$(document).on "turbolinks:load", ->
  App.init()
```

Yeah, it's time to wake up my browser.

Oh, just a moment. I forgot to comment additionally.
You can also add tui-editor to div tag without form element as follows:

```html
<div data-editor='tui-editor'></div>
```

If you insert this code in home#index page, don't forget to add `.home.index` class as follows:

```coffeescript
$(document).on "turbolinks:load", ->
  return unless $(".home.index, .posts.new, .posts.edit").length > 0
  tui_editor = new App.TuiEditor $("[data-editor='tui-editor']")
  tui_editor.render()
  tui_editor.form.submit (event) ->
    tui_editor.el.text $("##{tui_editor.el[0].id}-editor").tuiEditor 'getValue'  
```    

![](app/assets/images/screen_capture.png)