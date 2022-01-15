---
title: Installation
description: How to install Jekyll theme Twail
tags: [jekyll, twail]
cover: 'assets/images/unsplash-image-1.jpg'
last_modified_at:
---

## Jekyll theme Twail
This theme uses [jekyll-paginate-v2](https://github.com/sverrirs/jekyll-paginate-v2), which is not natively supported by Github Pages.  
But don't worry. You can still easily deploy to Github Pages.

### How to Install
1. You will need Ruby and Jekyll. [Install Ruby and Jekyll](https://jekyllrb.com/docs/installation/).
2. Fork [this repo](https://github.com/leetaewook/jekyll-theme-twail).
3. Write your own posts, and make your own settings in `_config.yml`.
   ```yaml   
   title: "Jekyll theme Twail"
   description: "Card stlye Jekyll theme for blog"
   baseurl: # TODO: If your Github Pages URL is https://usename.github.io/SOMETHING/, baseurl should be set to "/SOMETHING"
   ```
4. Change `Rakefile`.
   ```ruby
   # TODO: Write your Github Repository name
   GITHUB_REPONAME="github-user-name/repo-name"
   ```
5. Run command `rake publish`.
6. Change your Github Pages settings to use branch `gh-pages`.

