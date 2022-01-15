---
title: Jekyll 테마 만들어서 배포하기
description: 지킬 테마를 만들어서 배포하기까지의 과정을 적은 글입니다.
tags: [jekyll]
cover: '/images/make-jekyll-theme/cover.png'
last_modified_at:
---

## 다짐
Jekyll은 Ruby로 개발된 정적 사이트 생성기입니다. 마크다운으로 글을 작성하면, 그것을 바탕으로 HTML을 생성하여 웹사이트를 만들 수 있게 도와줍니다.

이 때 웹사이트가 가질 여러가지 기능과 디자인 가져다 쓰기 쉽도록 미리 만들어둔 것이 테마입니다.

블로그를 위한 Jekyll 테마를 찾아보다가, 개인적인 취향에 맞게 직접 테마를 만들어보기로 하였습니다.


## Jeykll 빈 테마 생성
[Jekyll 공식 문서](https://jekyllrb.com/docs/themes/#creating-a-gem-based-theme)에서는 지킬로 테마를 만드는 방법을 간략히 설명하고 있습니다.

Ruby가 설치되어 있다고 가정하겠습니다. Jekyll을 설치하고 새로운 테마를 만들어봅시다.
```shell
gem install bundler jekyll
jekyll new-theme my-theme-name
# my-theme-name 폴더에 빈 테마가 생성됩니다.
```

빈 테마를 생성하였다면, 폴더에는 `my-theme-name.gemspec` 파일이 존재할 것입니다. 우선 여기 적혀있는 `TODO`를 없앱시다. 왜냐하면 `.gemspec`에 `TODO`라는 단어가 있으면 bundle 시에 에러가 발생합니다.
```ruby
# my-theme-name.gemspec

# 여기 적혀있는 TODO들을 없앱시다.
spec.summary       = "My Jekyll theme!"
spec.homepage      = "https://github.com/YourName/RepoName"
```

그리고 다음 명령어로 Jekyll 개발 서버를 실행해봅니다.
```shell
bundle exec jekyll serve --port=4000
# http://127.0.0.1:4000에 개발 서버가 실행됩니다.
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/1.png">
</figure>
[http://127.0.0.1:4000](http://127.0.0.1:4000)에 접속하면 위와 같은 화면을 만날 수 있습니다. 서버는 동작하지만, 아직 레이아웃이 존재하지 않는 모습입니다.


## 포스트 작성하기
레이아웃을 작성하기 전에, 테스트로 사용할 포스트를 작성해봅시다.

Jeykll의 기본 명세에 따라 `/_posts/2021-01-01-pathname.md`와 같은 곳에 마크다운으로 글을 적습니다. 마크다운의 제일 앞 부분에는 대시 두 줄을 긋고 YAML 양식으로 해당 포스트의 타이틀, 카테고리, 태그와 같은 것들을 입력합니다.
```markdown
---
title: 테스트용 글입니다.
tags: [test, jekyll]
cover: https://source.unsplash.com/random
---

# 안녕하세요
테스트용 글입니다!
```

## _config.yml 작성하기
`/.config.yml`에서는 Jekyll과 관련된 여러 설정을 할 수 있습니다. 여기에 적는 값들은 나중에 Liquid로 레이아웃을 작성할 때 활용할 수 있습니다. HTML에 값들을 하드코딩으로 넣을 수도 있지만, 여기에 변수들로 적어놓으면 다른 사람들이 쉽게 변경해서 사용 할 수 있습니다.
```yaml
title: '나의 웹사이트'
locale: 'ko-KR'
# 나중에 레이아웃에서 site.title, site.locale과 같은 형식으로 사용할 수 있습니다.
```

## 레이아웃 작성하기
Jekyll은 HTML 작성을 위해 `Liquid`라는 템플릿 언어를 사용합니다. 지킬 박사와 하이드씨에서 지킬이 마시는 약이 연상되는 이름입니다.

Liquid는 어렵지 않아서, 코드를 바로 보면서 익히면 됩니다.

우선, 웹의 루트 페이지가 반환할 레이아웃을 `/index.html`에 작성합니다.
```markdown
---
layout: 'home' # 웹의 루트 페이지가 `/_layouts/home.html`을 반환하게 됩니다.
---
```

그리고 `/_layouts/home.html`을 작성합니다.
```markdown
---
layout: 'default'
---

<ul>
{% raw %}{% for post in site.posts %}
  <li>
    <a href="{{ post.url }}"><h3>{{ post.title }}</h3></a>
    <p>{{ post.content | strip_html | truncatewords: 33, "" }}</p>
  </li>
  <hr>
{% endfor %}{% endraw %}
</ul>
```
간략하게 현재 작성한 포스트들의 제목과 내용을 출력하도록 만들었습니다. 여기에 작성한 코드들은 default 레이아웃의 {% raw %}`{{ content }}`{% endraw %}에 들어가게 됩니다.

관습에 따라 `/_layouts/default.html`에는 모든 페이지에 적용될 레이아웃을 작성합니다.
```html
{% raw %}<!DOCTYPE html>
<html {% if site.locale %}lang={{ site.locale }}{% endif %}>
   <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>{% if page.title %}{{ page.title }}{% else %}{{ site.title }}{% endif %}</title>
   </head>
   <body>
      <header>헤더</header>
      <div>{{ content }}</div>
   </body>
</html>{% endraw %}
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/2.png">
</figure>

잘 만들어지고 있습니다.

## 페이지네이션 구현
작성한 `/_layouts/home.html`의 코드를 다시 한 번 봅시다.
```html
---
layout: default
---

{% raw %}<ul>
{% for post in site.posts %}
  <li>
    <a href="{{ post.url }}"><h3>{{ post.title }}</h3></a>
    <p>{{ post.content | strip_html | truncatewords: 33, "" }}</p>
  </li>
  <hr>
{% endfor %}
</ul>{% endraw %}
```

현재 for 구문의 posts에 갯수 제한이 없습니다. 저는 모든 posts 정보를 한번에 출력하는 대신에 페이지네이션을 구현하고 싶습니다.

그러기 위해서 for문에 갯수 제한을 두고, `/page1`, `/page2` 와 같은 방식으로 페이지네이션을 위한 페이지를 만들어주어야할 것입니다.

편안하게도, 이러한 기능이 Jekyll 플러그인으로 구현되어있습니다. 페이지네이션을 위한 플러그인으로는 `jekyll-paginate`를 사용할 수도 있고, `jekyll-paginate-v2`를 사용할 수도 있습니다. 

`jekyll-paginate`은 태그, 카테고리 등으로 분류된 상태에서 페이지네이션을 지원하지 않습니다. 반면에 `jekyll-paginate-v2`는 지원합니다.

그대신 `jekyll-paginate-v2`는 Github Page에서 지원하지 않는 플러그인이라는 단점이 있습니다. Github는 Jekyll로 작성된 코드를 그냥 푸시하는 것만으로 알아서 빌드해서 Github Page로 배포해주는데요, Github Page가 지원하지 않는 Jekyll 플러그인을 사용하면 로컬에서 빌드 후 푸시하여야합니다.

저는 태그 페이지에서도 페이지네이션을 적용하고 싶으므로, [jekyll-paginate-v2](https://github.com/sverrirs/jekyll-paginate-v2)를 택했습니다.

`/my-theme-name.gemspec`에 다음을 추가합니다.
```ruby
spec.add_runtime_dependency "jekyll-paginate-v2"
```

`/_config.yml`에 다음을 추가합니다.
```yaml
permalink: /:title

pagination:
  enabled: true
  per_page: 4
  permalink: '/page:num/'
  limit: 0
  sort_field: 'date'
  sort_reverse: true

plugins:
  - jekyll-paginate-v2
```

`/input.html`을 수정합니다.
```markdown
---
layout: home
pagination: 
  enabled: true
---
```

마지막으로, `/_layouts/home.html`을 수정합니다.
```markdown
---
layout: default
---

{% raw %}<ul>
{% for post in paginator.posts %}
  <li>
    <a href="{{ post.url }}"><h3>{{ post.title }}</h3></a>
    <p>{{ post.content | strip_html | truncatewords: 33, "" }}</p>
  </li>
  <hr>
{% endfor %}
</ul>

{% if paginator.total_pages > 1 %}
<ul>
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path }}">Newer</a>
  {% endif %}
  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path }}">Older</a>
  {% endif %}
</ul>
{% endif %}{% endraw %}
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/3.png">
</figure>

메인 페이지에 페이지네이션이 생겼습니다.


## 태그 구현
우선, `/_layouts/home.html`에서 포스트가 가지는 태그들도 같이 출력되도록 해봅시다.
```html
<ul>
{% raw %}{% for post in paginator.posts %}
  <li>
    <a href="{{ post.url }}"><h3>{{ post.title }}</h3></a>
    <p>{{ post.content | strip_html | truncatewords: 33, "" }}</p>

    <!-- 태그를 출력합니다 -->
    {% if post.tags %}
      {% for tag in post.tags %}
        <span>{{ tag }} </span>
      {% endfor %}
    {% endif %}

  </li>
  <hr>
{% endfor %}{% endraw %}
</ul>
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/4.png">
</figure>
포스트가 가지는 태그들이 출력됩니다.

이제, 태그들을 모아서 글을 볼 수 있도록 해봅시다. 이를 위해선 태그들 마다의 페이지를 만들어야할텐데, jekyll-paginate-v2이 자동적으로 페이지를 생성할 수 있게 도와줍니다.

`/_config.yml`에 추가합니다.
```yaml
autopages:
  enabled: true
  collections:
    enabled: false
  tags:
    enabled: true
    layouts:
      - autopage_tags.html
```

autopage를 위한 파일을 만들기 전에, 블로그에 존재하는 태그들이 무엇이 있나 확인할 수 있는 nav를 만들어봅시다. 저는 `/_layouts/default.html` 에 바로 넣었습니다.
```html
<!-- 생략 -->

{% raw %}<body>
  <header>헤더</header>
  <div>
    <nav>
      <hr>
      <h3>태그들의 목록</h3>
      {% for page in site.pages %}  
        {% if page.title and page.autogen == nil and page.autopage != nil %}
        <a href="{{ page.url }}">{{ page.autopage.display_name }}</a>
        {% endif %}
      {% endfor %}
      <hr>
    </nav>
    <div>{{ content }}</div>
  </div>
</body>{% endraw %}
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/5.png">
</figure>
블로그에 존재하는 태그들의 목록을 확인할 수 있습니다.

`/_layouts/autopage_tags.html`을 생성하고, 자동 생성될 태그 페이지가 가질 레이아웃을 정의합니다.
```html
---
layout: default
---

{% raw %}<div>
  <h1>태그: {% if page.autopages %}{{page.autopages.display_name}}{% endif %}</h1>

  <ul>
    {% for post in paginator.posts %}
      <li>
        <a href="{{ post.url }}"><h3>{{ post.title }}</h3></a>
        <p>{{ post.content | strip_html | truncatewords: 33, "" }}</p>    
        {% if post.tags %}
          {% for tag in post.tags %}
            <span>{{ tag }} </span>
          {% endfor %}
        {% endif %}
      </li>
      <hr>
    {% endfor %}
    </ul>

  {% if paginator.total_pages > 1 %}
  <ul>
    {% if paginator.previous_page %}
      <a href="{{ paginator.previous_page_path }}">Newer</a>
    {% endif %}
    {% if paginator.next_page %}
      <a href="{{ paginator.next_page_path }}">Older</a>
    {% endif %}
  </ul>
  {% endif %}
  
</div>{% endraw %}
```

<figure class="align-center">
   <img src="/images/make-jekyll-theme/6.png">
</figure>
이제 특정 태그에 관한 포스트만 확인할 수 있습니다.


## 스타일링
기능들은 대충 구현되었으니, 이제 블로그를 예쁘게 만들 차례입니다.

우선, 포스트를 눌렀을 때 사용할 레이아웃도 정의하여야합니다. `_config.yml`에 추가합니다.
```yaml
defaults:
  - values:
      layout: post
```
이제 `_post`에 작성된 마크다운은 기본적으로 `_layouts/post.html` 레이아웃을 사용하게 됩니다.

그리고  `_includes` 폴더에서 일종의 partial을 정의해두고 `{% raw %}{% include 파일명.html %}{% endraw %}`와 같이 가져다 쓸 수 있습니다. 예를 들면 다음과 같이 사용할 수 있습니다.

```markdown
<!-- /_includes/head.html -->

{% raw %}{% assign title_separator = site.title_separator | default: '-' | replace: '|', '&#124;' %}

{%- if paginator -%}
  {%- assign title = site.title -%}
{%- else -%}
  {%- assign title = page.title | append: " " | append: title_separator | append: " " | append: site.title -%}
{%- endif -%}
{%- assign title = title | markdownify | strip_html | strip_newlines | escape_once -%}

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{{ title | default: site.title }}</title>
	<link rel="stylesheet" href="/assets/css/main.css" />
</head>{% endraw %}
```

```markdown
<!-- /_layouts/default.html -->

{% raw %}<!DOCTYPE html>
<html {% if site.locale %}lang={{ site.locale }}{% endif %}>
  {% include head.html %}
  <body>
		<!-- 생략 -->
	</body>
</html>{% endraw %}
```

이제 대망의 ~~노가다~~ CSS 작업을 할 차례입니다. `/_sass` 폴더에 CSS와 관련된 여러 partial들을 작성하고, 그것을 `/assets/css/styles.scss`에서 import해서 사용하면 됩니다.

```scss
// _sass/main.scss

body {
  background-color: peru;
}
```

`/assets/css/styles.scss`에서는 특이한 점으로, Jekyll이 알아먹을 수 있게 앞에 대시 두 줄을 꼭 넣어야합니다.
```markdown
---
# assets/css/styles.scss
# this ensures Jekyll reads the file to be transformed into CSS later
---

@import 'main';
```

이제 partial을 나누어가며 HTML과 CSS 작업을 합니다.

메인 화면을 만드는 데에 저는 다음 테마들을 참조했습니다.
- [minimal-mistakes](https://github.com/mmistakes/minimal-mistakes)
- [hugo-theme-stack](https://github.com/CaiJimmy/hugo-theme-stack)

메인 화면 다음으로, 본문 화면 CSS를 작성하여야합니다. 마크다운이 HTML로 변환된 이후를 생각하여 CSS를 작성하여야하는데, 저는 다음을 참조하였습니다.
- [github-markdown-css](https://github.com/sindresorhus/github-markdown-css)
- [yue.css](https://github.com/lepture/yue.css/)

<figure class="align-center">
   <img src="/images/make-jekyll-theme/7.png">
</figure>
최종적으로 위와 같이 작업하였습니다.


## 배포하기
간단한 데모 페이지와 README를 작성하고, Github Repo에는 사람들이 잘 찾을 수 있도록 `jekyll-theme`와 같은 topic을 추가합니다.

이것만으로 해야 할 일은 다 한 것 같지만, gem도 빌드해서 배포해봅니다. 명령어 몇 줄로 정말 간단하게 배포할 수 있었습니다.
우선, [rubygems](https://rubygems.org/)에 회원가입합니다. 그리고 다음과 같이 빌드 후 푸시합니다.
```shell
gem build # .gem 파일이 생성됩니다.
gem push my-theme-name-0.0.1.gem # rubygems 사이트에 푸시됩니다.
```

제가 배포한 테마는 [jekyll-theme-twail](https://github.com/leetaewook/jekyll-theme-twail)에서 확인할 수 있습니다.
