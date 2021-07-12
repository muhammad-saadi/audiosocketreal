//= require arctic_admin/base
//= require ckeditor/init
//= require ckeditor/config
//= require active_admin/searchable_select

$(function () {
  var animationFilterDone = true;
  $(document).on('click touchstart', '#sidebar_toggle', function (e) {
    e.preventDefault();
    var sidebar = $('#sidebar')
    if (sidebar) {
      if (animationFilterDone === true) {
        animationFilterDone = false;
        var width = sidebar.width();
        var target = e.target;
        if (sidebar.css('right') === '0px') {
          sidebar.css('position', 'fixed');
          sidebar.animate({
            right: '-=' + width
          }, 600, function () {
            sidebar.removeAttr('style');
            animationFilterDone = true;
          });
        } else {
          sidebar.animate({
            right: '+=' + width
          }, 600, function () {
            sidebar.css('position', 'absolute');
            animationFilterDone = true;
          });
        }
      }
    }
  });
});
