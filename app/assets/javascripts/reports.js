$(document).ready(function() {
  $("#new_report")
    .on("ajax:success", function(event, data, status, xhr) {
      var link = document.createElement("a");
      var path = "reports/" + data["campaign_id"] + ".pdf"
      var text = document.createTextNode("Status Report");
      $("body").css('opacity', 1);

      $("#spinner").hide();
      link.setAttribute("href", path);
      link.appendChild(text);
      $(".report_campaign_id").removeClass("has-error");
      $(".help-block").remove();
      $("#report-generator").append(link);
    })
    .on("ajax:error", function(event, xhr, status, error) {
      var $errorElem = $('<span class="help-block"></span>');
      var $formElem = $('#new_report .report_campaign_id');
      errorMessage = JSON.parse(xhr.responseText);

      $("body").css('opacity', 1);
      $("#spinner").hide();
      $("span.help-block").remove();
      $errorElem.html(errorMessage["campaign_id"][0]);
      $formElem.addClass("has-error");
      $formElem.append($errorElem);
    });
    
    $("#new_report .btn").on("click", function(){
      $("body").css('opacity', 0.4);
      $("#spinner").show();
      $("#report-generator a").remove();
    });
});
