# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $("#new_selection").bind "ajax:complete", (event, xhr, status) ->
    $("input[id^='selection_']").val ""
    $('#selection-modal').foundation 'reveal', 'close'

  # Eliminar seleccion
  $("form").on "click", ".remove_selection", (event) ->
    # lo que se va a agregar
    selection_id = $(this).attr("id")
    # ids de selecciones a agregar
    selection_ids = $("#item_alternatives").val().split(",")
    # ids de selecciones a eliminar
    remove_selection_ids = $("#item_remove_alternatives").val().split(",")
    # Indice de la seleccion en los arreglos (siesque existe)
    index = selection_ids.indexOf(selection_id)
    remove_index = remove_selection_ids.indexOf(selection_id)
    # Ver si existe en agregar, si existe, eliminar
    if index > -1
      selection_ids.splice index, 1
    # Actualizar datos
    $("#item_alternatives").val selection_ids.join(",")
    remove_selection_ids.push(selection_id)
    remove_selection_ids = $.grep(remove_selection_ids, (n) ->
      n
    )
    $("#item_remove_alternatives").val remove_selection_ids.join(",")
    $(this).closest('tr').remove()
    event.preventDefault()
