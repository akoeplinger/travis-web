`import BasicView from 'travis/views/basic'`

View = BasicView.extend
  tabBinding: 'controller.tab'

  # hrm. how to parametrize bind-attr?
  classHome: (->
    'active' if @get('tab') == 'home'
  ).property('tab')

  classStats: (->
    'active' if @get('tab') == 'stats'
  ).property('tab')

  classProfile: (->
    classes = ['profile menu']
    classes.push('active') if @get('tab') == 'profile'
    classes.push(@get('controller.auth.state') || 'signed-out')
    classes.join(' ')
  ).property('tab', 'controller.auth.state')

  showProfile: ->
    $('#top .profile ul').show()

  hideProfile: ->
    $('#top .profile ul').hide()

`export default View`
