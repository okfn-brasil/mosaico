angular.module('fgvApp').filter 'slug', ->
  (str) ->
    return '' unless str
    slug = str.trim().toLowerCase()
    # remove accents, swap ñ for n, etc
    from = "àáäâãèéëêìíïîòóöôõùúüûñç·/_,:;"
    to   = "aaaaaeeeeiiiiooooouuuunc------"
    for char, i in from
      slug = slug.replace(new RegExp(char, 'g'), to.charAt(i))

    slug = slug.replace(/[^a-z0-9 -]/g, '') # remove invalid chars
               .replace(/\s+/g, '-') # collapse whitespace and replace by -
               .replace(/-+/g, '-'); # collapse dashes
