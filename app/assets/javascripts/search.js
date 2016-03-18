$(function() {
  $("form.nobottommargin").submit(function(e){
    e.preventDefault();
    var url = "/search"
    var data = $(this).serialize();
    $.ajax({
      url: url,
      method: 'GET',
      data: data,
    }).done(function(response){
      $('#search-tab').append(response);
    }).fail(function(response){
      console.log(response);
    })

  })
})
