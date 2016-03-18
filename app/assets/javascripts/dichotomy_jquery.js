$(function(){
  bindListners();
})

var bindListners = function(){
  $("#dataCarousel").on("click", '#arrowParent, #arrowRight, i.i-circled.i-small.icon-arrow-right', clickRight),
  $("#dataCarousel").on("click",'#arrowParent, #arrowLeft, i.i-circled.i-small.icon-arrow-left', clickLeft),
  $("#dataCarousel").on("click", '#arrowStepRight, #arrowStepLeft', goBack),
  $("#dataCarousel").on("click", "a", stopReload),
  $("body").tooltip({selector: '[data-toggle=tooltip]'}),
  $("#dataCarousel").on("click", "#re-carousel", continueThroughGroup);
}

var clickRight = function(e){
  e.preventDefault();
  optionId = ($(this).attr('data-id'));
  url = "/options/" + optionId
  $('#panel-right').css('border', '4px dotted #1ABC9C');
  $("#dataCarousel").animate({opacity: '0'}, function(){
      // ajax request starts
    $.ajax({
      method: "get",
      url: "/options/" + optionId
    }).done(function(response){
      console.log(response)
      $("#dataCarousel").html(response).animate({opacity: '1'});
    })
    .fail(function(response){
      console.log(response)
    })
  });
//Fade outAnimation Complete
}

var clickLeft = function(e){
  e.preventDefault();
  var optionId = $(this).attr('data-id');
  url = "/options/" + optionId
  $('#panel-left').css('border', '4px dotted #1ABC9C');
  $("#dataCarousel").animate({opacity: '0'}, function(){
      // ajax request starts
    $.ajax({
      method: "get",
      url: "/options/" + optionId
    }).done(function(response){
      console.log(response)
      $("#dataCarousel").html(response).animate({opacity: '1'});
    })
    .fail(function(response){
      console.log(response)
    })
  });
//Fade outAnimation Complete
}

var goBack = function(e){
  e.preventDefault();
  optionId = ($(this).attr('data-id'));
  $('#panel-left').css('border', '4px dotted #1ABC9C');
  $('#panel-right').css('border', '4px dotted #1ABC9C');
  $("#dataCarousel").animate({opacity: '0'}, function(){
      // ajax request starts
    $.ajax({
      method: "get",
      url: "/options/" + optionId
    }).done(function(response){
      console.log(response)
      $("#dataCarousel").html(response).animate({opacity: '1'});
    })
    .fail(function(response){
      console.log(response)
    })
  });
}

var stopReload = function(e){
  e.preventDefault();
}

var continueThroughGroup = function(e){
  e.preventDefault();
  route = $(this).attr('href');
  $("#dataCarousel").animate({opacity: '0'}, function(){
    $.ajax({
      method: "get",
      url: route
    })
    .done(function(response){
      $("#dataCarousel").html(response).animate({opacity: '1'});
    })
    .fail(function(response){
      console.log("fail");
      console.log(response);
    });
  });
}
