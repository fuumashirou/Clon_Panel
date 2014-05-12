# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $("#order-status").length != 0
    store_id = $("#store-id").html()
    if window.location["hostname"] == "panel.twable.com"
      server = io.connect("https://api.twable.com/orders?store=" + store_id, { secure: true })
    else if window.location["hostname"] == "localhost"
      server = io.connect("http://localhost:4000/orders?store=" + store_id)
    else
      server = io.connect("http://192.168.0.176:4000/orders?store=" + store_id)

    # Websocket status
    server.on "status", (message) ->
      if message == "connected"
        $(".orders").css "visibility", "visible"
        $("#order-status").css "margin-top", "0px"
        $(".order").html ""
        $(".bill").html ""
        server.emit "initialize"
        $("#order-status").css "visibility", "hidden"
    server.on "disconnect", ->
      $("#order-status").css "visibility", "visible"
      $("#order-status").css "margin-top", "100px"
      $(".orders").css "visibility", "hidden"
    # Order handler
    server.on "new_order", (order) ->
      order_data = order
      modifyUrl  = '/stores/' + store_id + '/orders/' + order_data.id + '/edit'
      printUrl   = '/stores/' + store_id + '/orders/' + order_data.id + '/print_order'
      items = []
      order_data.items.forEach (item) ->
        items.push item.name + ": " + item.quantity
      $(".order").append("
        <tr id='" + order_data.id + "'>
          <td>" + order_data.table_number + "</td>
          <td>" + (new Date(order_data.ordered_at)).toTimeString() + "</td>
          <td>" + items.join("<br />") + "</td>
          <td><a href=" + printUrl + " data-remote='true'><i class='fi-print big-icon'></i></a></td>
          <td><a href=" + modifyUrl + "><i class='fi-pencil big-icon'></i></a></td>
          <td><a href='#' class='remove'><i class='fi-checkbox big-icon'></i></a></td>
        </tr>")
      if order_data.received != true
        server.emit "order_received",
          order_id: order_data.id
      $("#ordersAudio")[0].play()
    # Bill handler
    server.on "new_billing", (bill) ->
      billing_data = bill
      discountUrl  = '/stores/' + store_id + '/checkin_billings/' + billing_data.id + '/discount'
      printUrl     = '/stores/' + store_id + '/orders/' + billing_data.id + '/print_bill'
      if billing_data.discount
        total_payment = parseFloat(billing_data.total) - parseFloat(billing_data.discount)
      else
        total_payment = parseFloat(billing_data.total)
      $(".bill").append("
        <tr id='" + billing_data.id + "'>
          <td>" + billing_data.table_number + "</td>
          <td>" + (new Date(billing_data.generated_at)).toTimeString() + "</td>
          <td>" + billing_data.payment_type + "</td>
          <td>" + total_payment + "</td>
          <td><a href=" + printUrl + " data-remote='true'><i class='fi-print big-icon'></i></a></td>
          <td><a href=" + discountUrl + "><i class='fi-price-tag big-icon'></i></a></td>
          <td><a href='#' class='remove'><i class='fi-checkbox big-icon'></i></a></td>
        </tr>")
      $("#ordersAudio")[0].play()

    $(document).on "click", ".remove", (event) ->
      self = $(this).parents("tr")
      type = self.parent("tbody").attr("class") # bill | order
      type_id = self.attr("id")
      server.emit "confirm_" + type,
        id: type_id
      self.remove()
      event.preventDefault()
