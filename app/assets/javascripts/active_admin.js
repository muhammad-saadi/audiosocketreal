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
    append_sub_filters(parent);
  })
})

function append_sub_filters(filter){
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

      for (let i = 0; i < data.length; i++){
        let child = data[i]
        let option = document.createElement('option');
        option.value = child[1];
        option.innerHTML = child[0];
        if (selected.includes(child[1].toString()))
          option.selected = true

        sub_filter.appendChild(option)
      }
    }
  });
}

$(function () {
  $(document).on('change', '.license_select', function (e) {
    let parent = e.target;
    append_license(parent);
  })
})

function append_license(collection) {
  var values = Array.from(collection.selectedOptions).map(({ value }) => value);
  $.ajax({
    dataType: 'json',
    type: 'GET',
    url: '/license',
    data: { ids: values },
    success: function(data) {
      let license = document.getElementById('collection_license');
      license.innerHTML = '';

      $.each(data, function(index, val){
        let child = val;
        let option = document.createElement('option');
        option.value = child;
        option.innerHTML = child;
        option.selected = true ;
        license.appendChild(option);
      });
    }
  })
}
