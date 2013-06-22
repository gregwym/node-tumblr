###
  node-tumblr 0.1.2
  (c) 2011-2013 Alexey Simonenko, Serenity LLC.
  Refactored and modified by Greg Wang
###

RequestUtils = require './requestutils'

# Blog
# ------

# Constructor
module.exports = Blog = (host, consumerKey, consumerSecret, token, tokenSecret) ->
  @host = host
  @consumerKey  = consumerKey
  @consumerSecret = consumerSecret
  @token = token
  @tokenSecret = tokenSecret

(->

  # Retrieve blog info.
  # This method returns general information about the blog,
  # such as the title, number of posts, and other high-level data.
  @info = (fn) ->
    url = RequestUtils.blogUrl 'info', @

    RequestUtils.apikeyGet url, fn

  # Retrieve blog avatar.
  # Get the blog's avatar in 9 different sizes.
  # The default size is 64x64.
  @avatar = (size, fn) ->
    [fn, size] = [size, null] if typeof size is 'function'
    url = RequestUtils.blogUrl 'avatar', @, {type:size}

    RequestUtils.apikeyGet url, fn

  # Retrieve blog's likes.
  # Return the publicly exposed likes from the blog.
  @likes = (options, fn) ->
    [fn, options] = [options, null] if typeof options is 'function'
    url = RequestUtils.blogUrl 'likes', @, options

    RequestUtils.apikeyGet url, fn

  # Retrieve published posts.
  # Posts are returned as an array attached to the posts field.
  @posts = (options, fn) ->
    [fn, options] = [options, null] if typeof options is 'function'

    url = RequestUtils.blogUrl 'posts', @, options

    RequestUtils.apikeyGet url, fn

  # Create alias for each type of posts and forward this call to @posts method
  alias = (self, type) ->
    self[type] = (options, fn) ->
      options = {} if not options
      options.type = type if not options.type
      @posts options, fn

  # Alias text, quote, link, answer, video, audio and photo posts
  alias @, type for type in ['text', 'quote', 'link', 'answer', 'video', 'audio', 'photo']

).call(Blog.prototype)
