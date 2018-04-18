    $(document).ready(function() {
    var updateTables = function() {
      $("table[switched]").each(function(i, element)
      {
        var contenedorTableResposive=($(element).parent().attr("class")=='scrollable'?$(element).parent().parent().parent():$(element).parent());
        if($(element).width()>contenedorTableResposive.width())
        {
            if($(element).attr("switched")!=='true')
            {
                $(element).attr("switched",'true');
                splitTable($(element));
                $(element).attr("class","responsive tablaReporte");
            }
        }
        else
        {
            if($(element).attr("switched")==='true')
            {
                $(element).attr("switched",'false');
                unsplitTable($(element));
                $(element).attr("class","");
            }
        }

     });
    };
    $(window).load(updateTables);
    $(window).on("redraw",function(){updateTables();}); // An event to listen for
    $(window).on("resize",function(){updateTables();});
   
	
    function splitTable(original)
    {
        original.wrap("<div class='table-wrapper' />");
        var copy = original.clone();
        copy.find("td:not(.responsiveVisible), th:not(.responsiveVisible)").css("display", "none");
        original.find("td.responsiveVisible,th.responsiveVisible").css("display", "none");
        copy.removeClass("responsive");
        copy.removeAttr("switched");
        original.closest(".table-wrapper").append(copy);

        copy.wrap("<div class='pinned' />");
        original.wrap("<div class='scrollable' />");
                //setCellHeights(original, copy);
    }

    function unsplitTable(original)
    {
            original.closest(".table-wrapper").find(".pinned").remove();
            original.unwrap();
            original.unwrap();
    }

    function setCellHeights(original, copy) {
    var tr = original.find('tr'),
        tr_copy = copy.find('tr'),
        heights = [];

    tr.each(function (index) {
      var self = $(this),
          tx = self.find('th, td');

      tx.each(function () {
        var height = $(this).outerHeight(true);
        heights[index] = heights[index] || 0;
        if (height > heights[index]) heights[index] = height;
      });

    });

    tr_copy.each(function (index) {
      $(this).height(heights[index]);
    });
    }

});
