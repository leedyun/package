import { assert } from '@esm-bundle/chai';

window.$ = window.jQuery = require('jquery')
window.TaskList = require('../../app/assets/javascripts/task_list.coffee')

describe "TaskList updates", ->
  beforeEach ->
    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @completeItem = $ '<li>', class: 'task-list-item'
    @completeCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @incompleteItem = $ '<li>', class: 'task-list-item'
    @incompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    # non-breaking space. See: https://github.com/github/task-lists/pull/14
    @nbsp = String.fromCharCode(160)
    @incompleteNBSPItem = $ '<li>', class: 'task-list-item'
    @incompleteNBSPCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @blockquote = $ '<blockquote>'

    @quotedList = $ '<ul>', class: 'task-list'

    @quotedCompleteItem = $ '<li>', class: 'task-list-item'
    @quotedCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @quotedIncompleteItem = $ '<li>', class: 'task-list-item'
    @quotedIncompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @innerBlockquote = $ '<blockquote>'

    @innerList = $ '<ul>', class: 'task-list'

    @innerCompleteItem = $ '<li>', class: 'task-list-item'
    @innerCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @innerIncompleteItem = $ '<li>', class: 'task-list-item'
    @innerIncompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @orderedList = $ '<ol>', class: 'task-list'

    @orderedCompleteItem = $ '<li>', class: 'task-list-item'
    @orderedCompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: true

    @orderedIncompleteItem = $ '<li>', class: 'task-list-item'
    @orderedIncompleteCheckbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
    """

    @changes =
      toComplete: """
      - [ ] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toQuotedComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [ ] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toInnerComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [ ] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toOrderedComplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [ ] ordered complete
      > 0. [ ] ordered incomplete
      """
      toIncomplete: """
      - [x] complete
      - [x] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toQuotedIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [x] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toInnerIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [x] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """
      toOrderedIncomplete: """
      - [x] complete
      - [ ] incomplete
      - [#{@nbsp}] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [x] ordered incomplete
      """
      toIncompleteNBSP: """
      - [x] complete
      - [ ] incomplete
      - [x] incompleteNBSP
      > - [x] quoted complete
      > - [ ] quoted incomplete
      >> - [x] inner complete
      > > - [ ] inner incomplete
      > 0. [x] ordered complete
      > 0. [ ] ordered incomplete
      """

    @completeItem.append @completeCheckbox
    @list.append @completeItem
    @completeItem.expectedIndex = 1

    @incompleteItem.append @incompleteCheckbox
    @list.append @incompleteItem
    @incompleteItem.expectedIndex = 2

    @incompleteNBSPItem.append @incompleteNBSPCheckbox
    @list.append @incompleteNBSPItem
    @incompleteNBSPItem.expectedIndex = 3

    @container.append @list
    @container.append @field

    @quotedCompleteItem.append @quotedCompleteCheckbox
    @quotedList.append @quotedCompleteItem
    @quotedCompleteItem.expectedIndex = 4

    @quotedIncompleteItem.append @quotedIncompleteCheckbox
    @quotedList.append @quotedIncompleteItem
    @quotedIncompleteItem.expectedIndex = 5

    @blockquote.append @quotedList

    @innerCompleteItem.append @innerCompleteCheckbox
    @innerList.append @innerCompleteItem
    @innerCompleteItem.expectedIndex = 6

    @innerIncompleteItem.append @innerIncompleteCheckbox
    @innerList.append @innerIncompleteItem
    @innerIncompleteItem.expectedIndex = 7

    @innerBlockquote.append @innerList
    @innerBlockquote.append @innerField

    @blockquote.append @innerBlockquote

    @container.append @blockquote

    @orderedCompleteItem.append @orderedCompleteCheckbox
    @orderedList.append @orderedCompleteItem
    @orderedCompleteItem.expectedIndex = 8

    @orderedIncompleteItem.append @orderedIncompleteCheckbox
    @orderedList.append @orderedIncompleteItem
    @orderedIncompleteItem.expectedIndex = 9

    @container.append @orderedList

    @blockquote.append @field

    @completeItemSourcePos = '1:1-1:14'
    @incompleteItemSourcePos = '2:1-2:16'
    @incompleteNBSPItemSourcePos = '3:1-3:27'
    @quotedCompleteItemSourcePos = '4:3-4:23'
    @quotedIncompleteItemSourcePos = '5:3-5:25'
    @innerCompleteItemSourcePos = '6:4-6:23'
    @innerIncompleteItemSourcePos = '7:5-7:26'
    @orderedCompleteItemSourcePos = '8:3-8:25'
    @orderedIncompleteItemSourcePos = '9:3-9:27'

    $('body').append(@container)
    @container.taskList()

    @setSourcePosition = (item, pos) =>
      item.attr('data-sourcepos', pos)
    
    @events = []

    @onChanged = =>
      utils =
      test: (fn) =>
        @events.push new Promise (resolve) =>
          @field.on 'tasklist:changed', (event) =>
            fn event
            resolve()
      eventHas: (name, value) =>
        utils.test (event) =>
          assert.equal event.detail[name], value
      fieldIs: (value) =>
        utils.test () =>
          assert.equal @field.val(), value
    
    @allEvents = =>
      for promise in @events
        await promise

  afterEach ->
    $(document).off 'tasklist:changed'
    @container.remove()

  it "updates the source, marking the incomplete item as complete", () ->
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @incompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toIncomplete)

    @incompleteCheckbox.click()

    await @allEvents()

  it "updates the source, marking the incomplete item as complete (sourcepos)", () ->
    @setSourcePosition(@incompleteItem, @incompleteItemSourcePos)
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @incompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toIncomplete)

    @incompleteCheckbox.click()

    await @allEvents()

  it "updates the source, marking the complete item as incomplete", () ->
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @completeItem.expectedIndex)
    @onChanged().fieldIs(@changes.toComplete)

    @completeCheckbox.click()

    await @allEvents()

  it "updates the source, marking the complete item as incomplete (sourcepos)", () ->
    @setSourcePosition(@completeItem, @completeItemSourcePos)
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @completeItem.expectedIndex)
    @onChanged().fieldIs(@changes.toComplete)

    @completeCheckbox.click()

    await @allEvents()

  # See: https://github.com/github/task-lists/pull/14
  it "updates the source for items with non-breaking spaces", () ->
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @incompleteNBSPItem.expectedIndex)
    @onChanged().fieldIs(@changes.toIncompleteNBSP)

    @incompleteNBSPCheckbox.click()

    await @allEvents()

  # See: https://github.com/github/task-lists/pull/14
  it "updates the source for items with non-breaking spaces (sourcepos)", () ->
    @setSourcePosition(@incompleteNBSPItem, @incompleteNBSPItemSourcePos)
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @incompleteNBSPItem.expectedIndex)
    @onChanged().fieldIs(@changes.toIncompleteNBSP)

    @incompleteNBSPCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted item, marking the incomplete item as complete", () ->
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @quotedIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toQuotedIncomplete)

    @quotedIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted item, marking the incomplete item as complete (sourcepos)", () ->
    @setSourcePosition(@quotedIncompleteItem, @quotedIncompleteItemSourcePos)
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @quotedIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toQuotedIncomplete)

    @quotedIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted item, marking the complete item as incomplete", () ->
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @quotedCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toQuotedComplete)

    @quotedCompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted item, marking the complete item as incomplete (sourcepos)", () ->
    @setSourcePosition(@quotedCompleteItem, @quotedCompleteItemSourcePos)
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @quotedCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toQuotedComplete)

    @quotedCompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted quoted item, marking the incomplete item as complete", () ->
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @innerIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toInnerIncomplete)

    @innerIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted quoted item, marking the incomplete item as complete (sourcepos)", () ->
    @setSourcePosition(@innerIncompleteItem, @innerIncompleteItemSourcePos)
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @innerIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toInnerIncomplete)

    @innerIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted quoted item, marking the complete item as incomplete", () ->
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @innerCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toInnerComplete)

    @innerCompleteCheckbox.click()

    await @allEvents()

  it "updates the source of a quoted quoted item, marking the complete item as incomplete (sourcepos)", () ->
    @setSourcePosition(@innerCompleteItem, @innerCompleteItemSourcePos)
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @innerCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toInnerComplete)

    @innerCompleteCheckbox.click()

    await @allEvents()

  it "updates the source of an ordered list item, marking the incomplete item as complete", () ->
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @orderedIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toOrderedIncomplete)

    @orderedIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of an ordered list item, marking the incomplete item as complete (sourcepos)", () ->
    @setSourcePosition(@orderedIncompleteItem, @orderedIncompleteItemSourcePos)
    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @orderedIncompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toOrderedIncomplete)

    @orderedIncompleteCheckbox.click()

    await @allEvents()

  it "updates the source of an ordered list item, marking the complete item as incomplete", () ->
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @orderedCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toOrderedComplete)

    @orderedCompleteCheckbox.click()

    await @allEvents()

  it "updates the source of an ordered list item, marking the complete item as incomplete (sourcepos)", () ->
    @setSourcePosition(@orderedCompleteItem, @orderedCompleteItemSourcePos)
    @onChanged().eventHas('checked', false)
    @onChanged().eventHas('index', @orderedCompleteItem.expectedIndex)
    @onChanged().fieldIs(@changes.toOrderedComplete)

    @orderedCompleteCheckbox.click()

    await @allEvents()

  setupListPrefix = ->
    @container.remove()

    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @item1 = $ '<li>', class: 'task-list-item'
    @item1Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @item2 = $ '<li>', class: 'task-list-item'
    @item2Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      [ ] one
      [ ] two
      - [ ] three
      - [ ] four
    """

    @changes = """
      [ ] one
      [ ] two
      - [ ] three
      - [x] four
    """

    @item1.append @item1Checkbox
    @list.append @item1
    @item1.expectedIndex = 1

    @item2.append @item2Checkbox
    @list.append @item2
    @item2.expectedIndex = 2

    @container.append @list
    @container.append @field

    $('body').append(@container)
    @container.taskList()

    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @item2.expectedIndex)
    @onChanged().fieldIs(@changes)

  it "update ignores items that look like Task List items but lack list prefix", () ->
    setupListPrefix.call this

    @item2Checkbox.click()

    await @allEvents()

  it "update ignores items that look like Task List items but lack list prefix (sourcepos)", () ->
    setupListPrefix.call this
    @item1.attr('data-sourcepos', '3:1-3:11')
    @item2.attr('data-sourcepos', '4:1-4:10')

    @item2Checkbox.click()

    await @allEvents()

  setupLinkItems = ->
    @container.remove()

    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @item1 = $ '<li>', class: 'task-list-item'
    @item1Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @item2 = $ '<li>', class: 'task-list-item'
    @item2Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      - [ ](link)
      - [ ][reference]
      - [ ]() collapsed
      - [ ][] collapsed reference
      - [ ] (no longer a link)
      - [ ] item
    """

    @changes = """
      - [ ](link)
      - [ ][reference]
      - [ ]() collapsed
      - [ ][] collapsed reference
      - [ ] (no longer a link)
      - [x] item
    """

    @item1.append @item1Checkbox
    @list.append @item1
    @item1.expectedIndex = 1

    @item2.append @item2Checkbox
    @list.append @item2
    @item2.expectedIndex = 2

    @container.append @list
    @container.append @field

    $('body').append(@container)
    @container.taskList()

    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @item2.expectedIndex)
    @onChanged().fieldIs(@changes)

  it "update ignores items that look like Task List items but are links", ->
    setupLinkItems.call this

    @item2Checkbox.click()

    await @allEvents()

  it "update ignores items that look like Task List items but are links (sourcepos)", ->
    setupLinkItems.call this
    @item1.attr 'data-sourcepos', '5:1-5:24'
    @item2.attr 'data-sourcepos', '6:1-6:10'

    @item2Checkbox.click()

    await @allEvents()

  setupTrailingLinks = ->
    @container.remove()

    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @item1 = $ '<li>', class: 'task-list-item'
    @item1Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @item2 = $ '<li>', class: 'task-list-item'
    @item2Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      - [ ] [link label](link)
      - [ ] [reference label][reference]
    """

    @changes = """
      - [ ] [link label](link)
      - [x] [reference label][reference]
    """

    @item1.append @item1Checkbox
    @list.append @item1
    @item1.expectedIndex = 1

    @item2.append @item2Checkbox
    @list.append @item2
    @item2.expectedIndex = 2

    @container.append @list
    @container.append @field

    $('body').append(@container)
    @container.taskList()

    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @item2.expectedIndex)
    @onChanged().fieldIs(@changes)

  it "updates items followed by links", ->
    setupTrailingLinks.call this

    @item2Checkbox.click()

    await @allEvents()

  it "updates items followed by links (sourcepos)", ->
    setupTrailingLinks.call this
    @item1.attr 'data-sourcepos', '1:1-1:24'
    @item2.attr 'data-sourcepos', '2:1-3:0'

    @item2Checkbox.click()

    await @allEvents()

  setupCodeBlocks = ->
    @container.remove()

    @container = $ '<div>', class: 'js-task-list-container'

    @list = $ '<ul>', class: 'task-list'

    @item1 = $ '<li>', class: 'task-list-item'
    @item1Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @item2 = $ '<li>', class: 'task-list-item'
    @item2Checkbox = $ '<input>',
      type: 'checkbox'
      class: 'task-list-item-checkbox'
      disabled: true
      checked: false

    @field = $ '<textarea>', class: 'js-task-list-field', text: """
      ```
      - [ ] test1
      - [ ] test2
      ```

      - [ ] test1
      - [ ] test2
    """

    @changes = """
      ```
      - [ ] test1
      - [ ] test2
      ```

      - [ ] test1
      - [x] test2
    """

    @item1.append @item1Checkbox
    @list.append @item1
    @item1.expectedIndex = 1

    @item2.append @item2Checkbox
    @list.append @item2
    @item2.expectedIndex = 2

    @container.append @list
    @container.append @field

    $('body').append(@container)
    @container.taskList()

    @onChanged().eventHas('checked', true)
    @onChanged().eventHas('index', @item2.expectedIndex)
    @onChanged().fieldIs(@changes)

  # See https://github.com/deckar01/task_list/issues/3
  it "doesn't update items inside code blocks", ->
    setupCodeBlocks.call this

    @item2Checkbox.click()

    await @allEvents()

  it "doesn't update items inside code blocks (sourcepos)", ->
    setupCodeBlocks.call this
    @item1.attr 'data-sourcepos', '6:1-6:11'
    @item2.attr 'data-sourcepos', '7:1-7:11'

    @item2Checkbox.click()

    await @allEvents()
