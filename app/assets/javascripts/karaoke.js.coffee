# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $("#karaoke-status").length != 0
    store_id = $("#store-id").html()
    if window.location.hostname == "panel.twable.com"
      server = io.connect("https://api.twable.com/karaoke?store=" + store_id, { secure: true })
    else if window.location.hostname == "localhost"
      server = io.connect("http://localhost:4000/karaoke?store=" + store_id)
    else
      server = io.connect("http://192.168.0.176:4000/karaoke?store=" + store_id)

    # Websocket status
    server.on "status", (message) ->
      if message == "connected"
        $(".songs").html ""
        server.emit "initialize"
      $("#karaoke-status").html message
    server.on "disconnect", ->
      $("#karaoke-status").html "disconnected"
    # Order handler
    server.on "new_song", (song) ->
      $(".songs").append("
        <tr id='" + song.id + "'>
          <td>" + song.table_number + "</td>
          <td>" + (new Date(song.ordered_at)).toTimeString() + "</td>
          <td>" + song.artist + " - " + song.title + "</td>
          <td><a href='#' class='remove'>remover de la lista</a></td>
        </tr>")

    $(document).on "click", ".remove", (event) ->
      self = $(this).parents("tr")
      id   = self.attr("id")
      server.emit("karaoke_status", { id: id, status: "delete" })
      self.remove()
      event.preventDefault()
