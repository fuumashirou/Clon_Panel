# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $("#waiter-status").length != 0
    store_id = $("#store-id").html()
    if window.location.hostname == "panel.twable.com"
      server = io.connect("https://api.twable.com/waiters?store=" + store_id, { secure: true })
    else if window.location.hostname == "localhost"
      server = io.connect("http://localhost:4000/waiters?store=" + store_id)
    else
      server = io.connect("http://192.168.0.176:4000/waiters?store=" + store_id)

    # Websocket status
    server.on "status", (message) ->
      if message == "connected"
        $(".waiter").html ""
        server.emit "initialize"
      $("#waiter-status").html message
    server.on "disconnect", ->
      $("#waiter-status").html "disconnected"
    # Order handler
    server.on "new_waiter", (waiter) ->
      waiter_data = waiter
      $(".waiter").append("
        <tr id='" + waiter_data.id + "'>
          <td>" + waiter_data.username + "</td>
          <td>" + (waiter_data.verified == true ? "Si" : "No") + "</td>
          <td>" + (new Date(waiter_data.checked_at)).toTimeString() + "</td>
          <td><a href='#' class='status'>verificar</a></td>
          <td><a href='#' class='remove'>remover</a></td>
        </tr>")
      # $("#waitersAudio")[0].play()

    $(document).on "click", ".status", (event) ->
      self = $(this).parents("tr")
      id   = self.attr("id")
      server.emit "waiter_status",
        id: id
        status: true
      event.preventDefault()

    $(document).on "click", ".remove", (event) ->
      self = $(this).parents("tr")
      id   = self.attr("id")
      server.emit "waiter_status",
        id: id
        status: "delete"
      self.remove()
      event.preventDefault()
