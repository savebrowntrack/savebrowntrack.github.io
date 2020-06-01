# [savebrowntrack.github.io](https://savebrowntrack.github.io)

This skeleton has been taken from the CS15 website, www.cs.brown.edu/courses/cs015/
I thought it would be easiest to take from this and re-vamp it.

Brown: #532F19
Light Green: #7FBAA8
Dark Green: #306F49
White: #FEFEFE
Black: #000000

## local dev setup
1. [install ruby](https://jekyllrb.com/docs/installation/)
2. `cd savebrowntrack.github.io`
3. `gem install bundler`
4. `bundle install`
5. `bundle exec jekyll serve`

## Important: all pages must start with a `---` block
To avoid duplicating code, please use a [front matter](https://jekyllrb.com/docs/front-matter/)
to start all html files. This will cause Jekyll to preprocess the html file to 
add all the scripts, css, google analytics, etc.

## TODOs
search codebase for "TODO" to find more.

- for the /screens/* pages, we should add a visual indication to scroll down
- add a favicon
- make landing page less busy--perhaps just the graphic + a scroll down arrow?
- navbar is too tall if tall skinny page, add max-height
- navbar occludes content
- presence of back home button is inconsistent -- we shoud make a new layout + variable. See `is_main_content` for an example 