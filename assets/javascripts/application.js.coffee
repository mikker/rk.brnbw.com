#= require spin.min

cl = -> console.log(arguments)

$ ->
  balance = $("#balance")
  if (balance.length > 0)
    spinner = new Spinner(spinner_opts).spin($("#circle")[0])
    $.ajax "/scrape",
      type: 'POST'
      success: (data, status, xhr) ->
        $("#balance").html(data.balance)
        $(".cloak").removeClass("cloak")
        spinner.stop()
      error: (xhr, status, error) ->
        cl arguments
        $("#circle").html(error)
        spinner.stop()


spinner_opts = {
  lines: 15,
  length: 0,
  width: 10,
  radius: 60,
  hwaccel: true,
  color: "#555",
  trail: 25,
}
