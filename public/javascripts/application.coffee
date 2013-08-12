updateSignBoard = (total) ->
  houses = []

  aux = total

  i = parseInt(aux / 100000)
  if i > 0
    houses.push i
  else
    houses.push 0

  aux -= i * 100000

  i = parseInt(aux / 10000)
  if i > 0
    houses.push i
  else
    houses.push 0

  aux -= i * 10000

  i = parseInt(aux / 1000)
  if i > 0
    houses.push i
  else
    houses.push 0

  aux -= i * 1000

  i = parseInt(aux / 100)
  if i > 0
    houses.push i
  else
    houses.push 0
    
  aux -= i * 100

  i = parseInt(aux / 10)
  if i > 0
    houses.push i
  else
    houses.push 0

  i = parseInt(aux % 10)
  houses.push i

  for x, i in houses
    spans.eq(i).text(x)

numbers = $(".signboard .numbers")
spans = numbers.find("span")

total = numbers.data("total")

updateSignBoard(total)

syncSignBoard = ->
  setTimeout ->
    $.getJSON '/counter.json', (data) ->
      if total != data.total
        updateSignBoard(data.total)

    syncSignBoard()
  , 2000

#syncSignBoard()

$("form").on "submit", (event) ->
  form = $ this
  form.find(".error").removeClass("error")

  $.ajax
    type: "POST"
    url: "/counter.json"
    data: form.serialize()
    success: (response) ->
      form.find("input").val("")
      updateSignBoard(response.total)
      $("#form").fadeOut ->
        $("#thanks").fadeIn()
    error: (xhr) ->
      error = $.parseJSON(xhr.responseText)
      field = form.find("#user-#{error.field}")
      field.addClass("error")
      field.focus()
      field.on "change", ->
        field.removeClass("error")
    dataType: "json"

  event.preventDefault()

$("a.facebook-share").on "click", (event) ->
  url = encodeURIComponent(location.href)
  window.open "https://www.facebook.com/sharer/sharer.php?u=#{url}", 'facebook-share-dialog', 'width=626,height=436'

  event.preventDefault()
