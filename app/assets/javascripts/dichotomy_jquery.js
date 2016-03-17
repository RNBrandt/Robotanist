$(function(){
  bindListners();
})

var bindListners = function(){
  $("#dataCarousel").on("click", '#arrowParent, #arrowRight, i.i-circled.i-small.icon-arrow-right', clickRight),
  $("#dataCarousel").on("click",'#arrowParent, #arrowLeft, i.i-circled.i-small.icon-arrow-left', clickLeft),
  $("#dataCarousel").on("click", '#arrowStepRight, #arrowStepLeft', goBack),
  $("#dataCarousel").on("click", "a", stopReload)
}

var clickRight = function(e){
  e.preventDefault();
  optionId = ($(this).attr('data-id'));
  url = "/options/" + optionId
  console.log(url)
}

var clickLeft = function(e){
  e.preventDefault();
  optionId = ($(this).attr('data-id'));
  url = "/options/" + optionId
  console.log(url)
}


var goBack = function(e){
  e.preventDefault();
  optionId = ($(this).attr('data-id'));
  url = "/options/"
}

var stopReload = function(e){
  e.preventDefault();
  // console.log(e)
}
