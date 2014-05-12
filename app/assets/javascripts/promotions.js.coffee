# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("#items").multiSelect
  selectableHeader: "<input type='text' class='search-input' autocomplete='off' placeholder='Buscar en menu'>"
  selectionHeader:  "<div class='custom-header'>Item agregados</div>"

  selectableOptgroup: true

  afterInit: (ms) ->
    that = this
    $selectableSearch = that.$selectableUl.prev()
    $selectionSearch  = that.$selectionUl.prev()
    selectableSearchString = "#" + that.$container.attr("id") + " .ms-elem-selectable:not(.ms-selected)"
    selectionSearchString  = "#" + that.$container.attr("id") + " .ms-elem-selection.ms-selected"

    that.qs1 = $selectableSearch.quicksearch(selectableSearchString).on("keydown", (e) ->
      if e.which is 40
        that.$selectableUl.focus()
        false
    )

  afterSelect: ->
    @qs1.cache()

  afterDeselect: ->
    @qs1.cache()
