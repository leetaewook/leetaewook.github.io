---
title: Google Fonts처럼 다이나믹 서브셋 폰트 만들어 사용하기
description: 다이나믹 서브셋은 CSS의 unicode-range 속성을 이용하여 해당 유니코드 영역의 문자가 사용될 때 폰트를 다운로드 하는 방식을 말합니다.
tags: [frontend]
cover: '/images/dynamic-subset-font/cover.png'
last_modified_at: 2022-01-16T05:08:32+09:00
---

## 다이나믹 서브셋이란 | Dynamic Subset
한글은 조합형 문자로, 만들어낼 수 있는 문자의 수가 11172자나 됩니다.

TTF 포맷의 경우, 로마자 폰트는 용량이 200KB가 안 되는 데에 비하여 한글 11172자를 모두 담은 폰트는 2MB가 넘습니다.

폰트 파일의 용량을 줄이기 위해서 서브셋 폰트를 이용할 수 있습니다.

일반적인 서브셋 폰트는 한글 11172자에서 일반적으로 쓰이지 않는 문자를 제거하고 2350자만을 사용하는 것을 말합니다. 글자 수가 1/5로 줄었으니 용량도 그만큼 줄어듭니다. 하지만 지원하지 않는 글자가 있다는 점은 사용자가 임의로 글을 작성할 수 있는 채팅, 게시글과 같은 곳에서 크나큰 단점으로 다가옵니다.

다이나믹 서브셋은 CSS의 `unicode-range` 속성을 이용하여 해당 유니코드 영역의 문자가 사용될 때 브라우저가 폰트 파일를 다운로드 하는 방식을 말합니다.
```css
/* 다이나믹 서브셋 폰트 예시 */
/* Google Fonts Noto Sans KR */
/* https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap */


/* [0] */
@font-face {
  font-family: 'Noto Sans KR';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/notosanskr/v25/PbykFmXiEBPT4ITbgNA5Cgm203Tq4JJWq209pU0DPdWuqxJFA4GNDCBYtw.0.woff2) format('woff2');
  unicode-range: U+f9ca-fa0b, U+ff03-ff05, U+ff07, U+ff0a-ff0b, U+ff0d-ff19, U+ff1b, U+ff1d, U+ff20-ff5b, U+ff5d, U+ffe0-ffe3, U+ffe5-ffe6;
}
/* [1] */
@font-face {
  font-family: 'Noto Sans KR';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(https://fonts.gstatic.com/s/notosanskr/v25/PbykFmXiEBPT4ITbgNA5Cgm203Tq4JJWq209pU0DPdWuqxJFA4GNDCBYtw.1.woff2) format('woff2');
  unicode-range: U+f92f-f980, U+f982-f9c9;
}
/* ... */
```
이를 통해 커다란 통짜 폰트 파일이 아닌, 실제 사용되는 글자가 담긴 폰트 파일만을 다운로드 할 수 있습니다.

그래서 `unicode-range`를 어떻게 나눌지가 관건입니다. 영역은 몇 개로 나눌지, 어떤 글자끼리 영역을 묶어야 할지 최적의 수를 찾아야 할 텐데, 구글은 머신 러닝을 통해 사용 빈도수별로 글자를 분류하여 다이나믹 서브셋 폰트를 제공하고 있습니다. 한글 폰트의 경우 120개의 그룹으로 나누어 두었습니다.

<figure class="align-center">
   <img src="/images/dynamic-subset-font/char-frequency.png">
</figure>

[Google Fonts의 한국어 지원에 관한 글](https://www.googblogs.com/tag/korean/)

저희는 구글의 결과물(CSS)을 참조하여 폰트 파일을 쪼개면 되겠습니다.

## 다이나믹 서브셋 만들기
Google Fonts의 unicode-range를 참조하여 폰트 파일을 쪼개야합니다.

단순 노가다로 폰트를 나누는 대신, [black7375님이 만든 font-range 라이브러리](https://github.com/black7375/font-range)를 이용합니다.
```bash
# font-range 라이브러리 설치
npm init -y
npm i font-range
pip install fonttools zopfli brotli # font-range의 dependencies
```

```jsx
// main.js
import { fontRange } from 'font-range';

fontRange(
  'https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap',
  '/Users/twain/Downloads/GmarketSansOTF/Gmarket Sans.otf',
  {
    savePath: './Gmarket Sans/',
    format: 'woff2',
  },
);
```

```bash
node main.js
```

<figure class="align-center">
   <img src="/images/dynamic-subset-font/1.png" style="width: 360px;">
</figure>
폰트들이 120개의 그룹으로 쪼개집니다.

같이 생성된 CSS 파일의 font-familly, font-style, font-weight, src를 폰트에 알맞게 수정합니다.
```css
/* 최종적으로 생성된 다이나믹 서브셋 폰트 CSS */

/* [0] */
@font-face {
  font-family: 'Gmarket Sans';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(./GmarketSans_0.woff2) format('woff2');
  unicode-range: U+f9ca-fa0b, U+ff03-ff05, U+ff07, U+ff0a-ff0b, U+ff0d-ff19, U+ff1b, U+ff1d, U+ff20-ff5b, U+ff5d, U+ffe0-ffe3, U+ffe5-ffe6;
}
/* [1] */
@font-face {
  font-family: 'Gmarket Sans';
  font-style: normal;
  font-weight: 400;
  font-display: swap;
  src: url(./GmarketSans_1.woff2) format('woff2');
  unicode-range: U+f92f-f980, U+f982-f9c9;
}
/* ... */
```

이제 웹사이트에서는 해당 CSS 파일을 import하여 사용하면 됩니다.
```html
<!DOCTYPE html>
<html>
  <head>
    <style>
      * {
        font-family: 'Gmarket Sans';
      }
    </style>
    <link rel="stylesheet" href="./GmarketSans/GmarketSans.css" />
  </head>
  <body>
    <p>테스트 가나다라마바사 뷁쉙</p>
  </body>
</html>
```

<figure class="align-center">
   <img src="/images/dynamic-subset-font/2.png">
</figure>
페이지에서 실제 사용되는 글자만을 다운로드하는 모습으로, 다이나믹 서브셋 폰트가 잘 적용되고 있습니다.

## 마치며
이렇게 만든 폰트와 CSS 파일은 CDN에 업로드 해두고 이용하면 편리합니다.

Gmarket Sans 폰트의 다이나믹 서브셋을 Github CDN에 올려두었으니 이용하실 분들은 이용해주세요.
[https://github.com/leetaewook/gmarket-sans-dynamic-subset](https://github.com/leetaewook/gmarket-sans-dynamic-subset)

그리고 폰트의 라이센스에 주의하여야합니다. 많은 폰트들은 폰트 파일의 수정과 재배포에 제약을 가하고 있습니다. 하지만 이를 허용하는 폰트도 많이 있으니, 가능하다면 다이나믹 서브셋을 통하여 웹사이트들을 최적화하면 좋을 것 같습니다.
