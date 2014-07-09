RootView = require 'views/kinds/RootView'
template = require 'templates/kinds/user'
User = require 'models/User'

module.exports = class UserView extends RootView
  template: template
  className: 'user-view'

  constructor: (options, @nameOrID) ->
    super options

    @listenTo @, 'userLoaded', @onUserLoaded
    @listenTo @, 'userNotFound', @ifUserNotFound

    # TODO Ruben Assume ID for now
    @user = User.getByID @nameOrID, {}, true,
      success: (user) =>
        @trigger 'userNotFound' unless user
        @trigger 'userLoaded', user
      error: =>
        console.debug 'Error while fetching user'
        @trigger 'userNotFound'

  getRenderData: ->
    context = super()
    context.currentUserView = 'Achievements'
    context.user = @user unless @user?.isAnonymous()
    context

  isMe: -> @nameOrID is me.id

  onUserLoaded: (user) ->
    console.log 'onUserLoaded', user

  ifUserNotFound: ->
    console.warn 'user not found'

  onLoaded: ->
    super()
