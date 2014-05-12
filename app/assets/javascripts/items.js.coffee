# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  # Item Selections
  if $(".current-selection-data").length != 0
    if $(".current-selection-data").html() is ""
      options = []
    else
      options = $(".current-selection-data").html().split(";")

    selections = JSON.parse($(".selection-data").html());
    templates  = JSON.parse($(".template-data").html())
    $("input[id^='item_selections_attributes_'][id$='_selections_items']").each (index) ->
      id = $(this).attr("id").split("_")[3]
      $(this).val(selections[id]["items"].join(";"))
      $(this).select2 tags: options, width: "100%", tokenSeparators: [";"], separator: ";"

  $("form").on "click", ".remove_item", (event) ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".item").hide()
    event.preventDefault()

  $("form").on "click", ".add_fields", (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data("id"), "g")
    $(this).after($(this).data("fields").replace(regexp, time))
    event.preventDefault()

  title = true
  template = false
  $("form").on "click", ".use_template", (event) ->
    title_input = $(".selection-title")
    template_input = $(".selection-template")
    if title is false
      title_input.show()
      title_input.prop "disabled", false
      $(".use_template").text "Usar existente"
      title = true
    else if title is true
      title_input.hide()
      title_input.prop "disabled", true
      $(".use_template").text "Crear nueva"
      title = false
    if template is false
      template_input.show()
      $(".form").hide()
      template_input.prop "disabled", false
      template = true
    else if template is true
      template_input.hide()
      $(".form").show()
      template_input.prop "disabled", true
      template = false
    event.preventDefault()

  # Item type/category
  if $("#item_type").length != 0
    categories = $("#item_category").html()
    $("#item_category").html $(categories).filter("optgroup[label='#{$("#item_type :selected").text()}']").html()
    $("#item_category").select2 width: "100%"

  $("form").on "change", "#item_price", (event) ->
    $("#item_hh_price").val(Math.round(parseFloat($(this).val()) / 2))

  $("form").on "change", "input[name~='item[happy_hour]']", (event) ->
    if $(this).val() == "true"
      $(".hh_price").show()
      $(".hh_price :input").prop("disabled", false)
    else
      $(".hh_price").hide()
      $(".hh_price :input").prop("disabled", true)

  $("form").on "change", "#item_type", (event) ->
    type    = $("#item_type :selected").text()
    options = $(categories).filter("optgroup[label='#{type}']").html()
    if options
      $("#item_category").html options
    else
      $("#item_category").empty()
    $("#item_category").select2 width: "100%"

    if type == "Comidas"
      $(".happy_hour").hide()
      $(".happy_hour :input").each () ->
        $(this).prop("disabled", true)
    if type == "Tragos"
      $(".happy_hour").show()
      $(".happy_hour :input").each () ->
        $(this).prop("disabled", false)

  # Selection templates
  values = ["title", "selections_items", "aditional_price", "items_limit"]
  $("form").on "change", "#selections_templates", (event) ->
    parent = $(this).closest("fieldset")
    template = $(this).val()
    for value in values
      if value is "selections_items"
        parent.find("input[id$=" + value + "]").val(templates[template]["items"].join(";")).trigger("change")
      else
        parent.find("input[id$=" + value + "]").val(templates[template][value])


