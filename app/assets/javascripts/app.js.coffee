App = window.App = Ember.Application.create()

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: 'api/v1'

App.Router.map ->
  @resource 'about'
  @resource 'todos', ->
    @resource 'todo', { path: ':todo_id' }

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo('todos')

##TODOS
App.TodosController = Ember.ArrayController.extend
  todosCount: (-> @get('model.length')).property('@each')
  actions:
    createTodo: ->
      title = @get('title')
      return if !title or !title.trim()

      todo = @store.createRecord 'todo',
        title     : title
        completed : false

      @set('title', '')
      todo.save()
      return

App.TodosRoute = Ember.Route.extend
  model: -> @store.find('todo')

##TODO
App.Todo = DS.Model.extend
  title     : DS.attr('string')
  completed : DS.attr('boolean')
App.TodoRoute = Ember.Route.extend
  model: (params)-> @store.find('todo', params.todo_id)
App.TodoController = Ember.ObjectController.extend
  actions:
    edit: ->
      @set('isEditing', true)
    acceptChanges: ->
      @set('isEditing', false)
      if Ember.isEmpty( @get('model.title') )
        @send('delete')
      else
        @get('model').save()
    delete: ->
      todo = @get('model')
      todo.deleteRecord()
      todo.save()

  isEditing: false

  isCompleted: ((key, value)->
    model = @get('model')
    if value is undefined
      return model.get('completed')
    else
      model.set('completed', value)
      model.save()
      return value
  ).property('model.completed')

App.EditTodoView = Ember.TextField.extend
  didInsertElement: -> this.$().focus()


## HELPERS
Ember.Handlebars.helper 'edit-todo', App.EditTodoView
Ember.Handlebars.helper 'format-markdown', (input)-> new Handlebars.SafeString(input)
Ember.Handlebars.helper 'format-date', (date)-> moment(date).fromNow()
