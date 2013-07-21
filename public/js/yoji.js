function goto_line(elem){
  var h = $(elem).position().top
  $(document.body).animate({scrollTop: h}, 'fast')
}

$(document.body).ready(function(){
  var hash = window.location.hash
  var matched = hash.match(/#(\d+)/)
  if(!matched){
    return
  }
  var linum = matched[1]
  var elem = document.getElementById('L' + linum)
  if(elem){
    goto_line(elem)
  }
})