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

$(function () {
  $(document).on('change', '.filter_select', function (e) {
    let parent = e.target
    sub_filters(parent);
  })
})

function sub_filters(filter){
  var values = Array.from(filter.selectedOptions).map(({ value }) => value);
  $.ajax({
    type: "GET",
    dataType: "json",
    url: "/api/v1/filters/sub_filters",
    data: { ids: values},
    success: function(data) {
      let sub_filter = document.getElementById(filter.id + "-children")
      let selected = Array.from(sub_filter.selectedOptions).map(({ value }) => value);
      sub_filter.innerHTML = ''

      for (let i = 0; i < data.length; i++)
        for (let j = 0; j < data[i].length; j++) {
          let child = data[i][j]
          let option = document.createElement('option');
          option.value = child[0];
          option.innerHTML = child[1];
          if (selected.includes(child[0].toString()))
            option.selected = true

          document.getElementById(filter.id + "-children").appendChild(option)
        }
    }
  });
}
