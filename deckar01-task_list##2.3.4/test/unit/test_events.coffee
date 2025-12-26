window.$ = window.jQuery = require('jquery')
window.TaskList = require('../../app/assets/javascripts/task_list.coffee')

describe "TaskList events", ->
  beforeEach ->
    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'
    @item = $ '<li>', class: 'task-list-item'
    @checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', "- [ ] text"

    @item.append @checkbox
    @list.append @item
    @container.append @list

    @container.append @field

    $('body').append @container
    @container.taskList()

  afterEach ->
    $(document).off 'tasklist:enabled'
    $(document).off 'tasklist:disabled'
    $(document).off 'tasklist:change'
    $(document).off 'tasklist:changed'
    @container.remove()

  it "triggers a tasklist:change event before making task list item changes", (done) ->
    @field.on 'tasklist:change', -> done()

    @checkbox.click()

  it "triggers a tasklist:changed event once a task list item changes", (done) ->
    @field.on 'tasklist:changed', -> done()

    @checkbox.click()

  it "can cancel a tasklist:changed event", ->
    event1 = new Promise (resolve) =>
      @field.on 'tasklist:change', (event) ->
        event.preventDefault()
        resolve()

    flush = null
    event2 = new Promise (resolve, reject) =>
      @field.on 'tasklist:changed', -> reject()
      flush = resolve

    @checkbox.click()

    await event1
    flush()
    await event2

  it "enables task list items when a .js-task-list-field is present", (done) ->
    $(document).on 'tasklist:enabled', -> done()
    
    @container.taskList()

  it "doesn't enable task list items when a .js-task-list-field is absent", ->
    flush = null
    event = new Promise (resolve, reject) ->
      $(document).on 'tasklist:enabled', -> reject()
      flush = resolve

    @field.remove()
    @container.taskList()

    flush()
    await event
