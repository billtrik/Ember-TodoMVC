App = window.App = Ember.Application.create()

App.ApplicationAdapter = DS.RESTAdapter.extend
  host: 'api/v1'

App.Router.map ->
  @resource 'about'
  @resource 'todos', ->
    @resource 'todo', { path: ':todo_id' }, ->
      @route 'create'
      @route 'edit'
      @route 'delete'
      return
    return

App.IndexRoute = Ember.Route.extend
  redirect: -> @transitionTo('todos')

##TODOS
App.TodosController = Ember.ArrayController.extend
  todosCount: (-> @get('model.length')).property('@each')
App.TodosRoute = Ember.Route.extend
  model: -> @store.find('todo')

##TODO
App.Todo = DS.Model.extend
  title     : DS.attr('string')
  completed : DS.attr('boolean')
App.TodoRoute = Ember.Route.extend
  model: (params)-> @store.find('todo', params.todo_id)

App.TodoEditController = Ember.ObjectController.extend
  actions:
    save: ->
      todo = @get('model')
      # this will tell Ember-Data to save/persist the new record
      todo.save()
      # then transition to the current todo
      @transitionToRoute('todos')
  isNiam: false
App.TodoEditRoute = Ember.Route.extend
  model: -> return @modelFor('todo')
App.TodoEditView = Ember.View.extend
  templateName: 'todo_edit'
App.TodoController = Ember.ObjectController.extend
  actions:
    save: ->
      console.log arguments
    toggleCompleted: ->
      console.log arguments
    edit: ->
      @transitionToRoute('user.edit')

  isCompleted: ((key, value)->
    model = this.get('model')
    if value is undefined
      return model.get('completed')
    else
      model.set('completed', value)
      model.save()
      return value
  ).property('model.completed')

  isEditing: false
  edit:  -> @set('isEditing', true)
  doneEditing: ->
    @set('isEditing', false)
    @get('store').commit()


## HELPERS
Ember.Handlebars.helper 'format-markdown', (input)-> new Handlebars.SafeString(input)
Ember.Handlebars.helper 'format-date', (date)-> moment(date).fromNow()
