<!DOCTYPE html>
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<title>Tooltips</title>

	<script src='codebase/dhtmlxscheduler.js' type="text/javascript" charset="utf-8"></script>
	<script src='codebase/ext/dhtmlxscheduler_timeline.js' type="text/javascript" charset="utf-8"></script>
	<script src="codebase/ext/dhtmlxscheduler_serialize.js" type="text/javascript" charset="utf-8"></script>
	<script src='codebase/ext/dhtmlxscheduler_tooltip.js' type="text/javascript" charset="utf-8"></script>

	<link rel='stylesheet' type='text/css' href='codebase/dhtmlxscheduler.css'>
    <script src="../js/general.js"></script>
    

	<style type="text/css" media="screen">
		html, body{
			margin:0;
			padding:0;
			height:100%;
			overflow:hidden;
		}
	</style>

	<script type="text/javascript" charset="utf-8">
        function nuevoAjax()
                {
                    var xmlhttp=false;
                    try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (E) {
                            xmlhttp = false;
                        }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                        xmlhttp = new XMLHttpRequest();
                    }

                    return xmlhttp;
                }
        function cargarSeccionesMaquinas()
            {
                var seccionesMaquina = "";
                ajax=nuevoAjax();

                ajax.open("GET","ajaxCargarMaquina.jsp?cod="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        seccionesMaquina = ajax.responseText;
                    }
                }
                ajax.send(null);

                //alert(seccionesMaquina.replace("\\n", ""));
                //alert(seccionesMaquina);
                return seccionesMaquina;
            }
       function cargarCronogramaMaquinas()
            {
                var cronogramaMaquina = "";
                ajax=nuevoAjax();

                ajax.open("GET","ajaxCargarCronograma.jsp?cod="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        cronogramaMaquina = ajax.responseText;
                    }
                }
                ajax.send(null);
                //alert(cronogramaMaquina);
                return cronogramaMaquina;
            }
		function init() {
			//===============
			// Basic configuration
			//===============
			scheduler.locale.labels.timeline_tab = "Timeline";
			scheduler.locale.labels.section_custom="Section";
			scheduler.config.details_on_create=true;
			scheduler.config.details_on_dblclick=true;
			scheduler.config.xml_date="%Y-%m-%d %H:%i";

			//===============
			// Tooltip related code
			//===============

			// we want to save "dhx_cal_data" div in a variable to limit look ups
			var scheduler_container = document.getElementById("scheduler_here");
			var scheduler_container_divs = scheduler_container.getElementsByTagName("div");
			var dhx_cal_data = scheduler_container_divs[scheduler_container_divs.length-1];

			// while target has parent node and we haven't reached dhx_cal_data
			// we can keep checking if it is timeline section
			scheduler.dhtmlXTooltip.isTooltipTarget = function(target) {
				while (target.parentNode && target != dhx_cal_data) {
					var css = target.className.split(" ")[0];
					// if we are over matrix cell or tooltip itself
					if (css == "dhx_matrix_scell" || css == "dhtmlXTooltip") {
						return { classname: css };
					}
					target = target.parentNode;
				}
				return false;
			};

			scheduler.attachEvent("onMouseMove", function(id, e) {
				var timeline_view = scheduler.matrix[scheduler.getState().mode];

				// if we are over event then we can immediately return
				// or if we are not on timeline view
				if (id || !timeline_view) {
					return;
				}

				// native mouse event
				e = e||window.event;
				var target = e.target||e.srcElement;

				var tooltip = scheduler.dhtmlXTooltip;
				var tooltipTarget = tooltip.isTooltipTarget(target);
				if (tooltipTarget) {
					if (tooltipTarget.classname == "dhx_matrix_scell") {
						// we are over cell, need to get what cell it is and display tooltip
						var section_id = scheduler.getActionData(e).section;
						var section = timeline_view.y_unit[timeline_view.order[section_id]];

						// showing tooltip itself
						var text = "Tooltip for <b>"+section.label+"</b>";
						tooltip.delay(tooltip.show, tooltip, [e, text]);
					}
					if (tooltipTarget.classname == "dhtmlXTooltip") {
						dhtmlxTooltip.delay(tooltip.show, tooltip, [e, tooltip.tooltip.innerHTML]);
					}
				}
			});

			//===============
			// Timeline configuration
			//===============
			var sections=[
				{key:1, label:"James Smith"},
				{key:2, label:"John Williams"},
				{key:3, label:"David Miller"},
				{key:4, label:"Linda Brown"}
			];

			scheduler.createTimelineView({
				name:	"timeline",
				x_unit:	"minute",
				x_date:	"%H:%i",
				x_step:	30,
				x_size: 24,
				x_start: 16,
				x_length:	48,
				y_unit:	sections,
				y_property:	"section_id",
				render:"bar"
			});

			//===============
			// Data loading
			//===============
			scheduler.config.lightbox.sections=[
				{name:"description", height:130, map_to:"text", type:"textarea" , focus:true},
				{name:"custom", height:23, type:"select", options:sections, map_to:"section_id" },
				{name:"time", height:72, type:"time", map_to:"auto"}
			];

			scheduler.init('scheduler_here',new Date(2009,5,30),"timeline");
			scheduler.parse([
				{ start_date: "2009-06-30 09:00", end_date: "2009-06-30 12:00", text:"Task A-12458", section_id:1},
				{ start_date: "2009-06-30 10:00", end_date: "2009-06-30 16:00", text:"Task A-89411", section_id:1},
				{ start_date: "2009-06-30 10:00", end_date: "2009-06-30 14:00", text:"Task A-64168", section_id:1},
				{ start_date: "2009-06-30 16:00", end_date: "2009-06-30 17:00", text:"Task A-46598", section_id:1},

				{ start_date: "2009-06-30 12:00", end_date: "2009-06-30 20:00", text:"Task B-48865", section_id:2},
				{ start_date: "2009-06-30 14:00", end_date: "2009-06-30 16:00", text:"Task B-44864", section_id:2},
				{ start_date: "2009-06-30 16:30", end_date: "2009-06-30 18:00", text:"Task B-46558", section_id:2},
				{ start_date: "2009-06-30 18:30", end_date: "2009-06-30 20:00", text:"Task B-45564", section_id:2},

				{ start_date: "2009-06-30 08:00", end_date: "2009-06-30 12:00", text:"Task C-32421", section_id:3},
				{ start_date: "2009-06-30 14:30", end_date: "2009-06-30 16:45", text:"Task C-14244", section_id:3},

				{ start_date: "2009-06-30 09:20", end_date: "2009-06-30 12:20", text:"Task D-52688", section_id:4},
				{ start_date: "2009-06-30 11:40", end_date: "2009-06-30 16:30", text:"Task D-46588", section_id:4},
				{ start_date: "2009-06-30 12:00", end_date: "2009-06-30 18:00", text:"Task D-12458", section_id:4}
			],"json");
		}
		function show() {
		alert(scheduler.toJSON());
		}
	</script>
</head>
<body onload="init();">
<input type="button" name="show" value="Show" onclick="show()" style="right:400px;" />
<div id="scheduler_here" class="dhx_cal_container" style='width:100%; height:100%;'>
	<div class="dhx_cal_navline">
		<div class="dhx_cal_prev_button">&nbsp;</div>
		<div class="dhx_cal_next_button">&nbsp;</div>
		<div class="dhx_cal_today_button"></div>
		<div class="dhx_cal_date"></div>
		<div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>
		<div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>
		<div class="dhx_cal_tab" name="timeline_tab" style="right:280px;"></div>
		<div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>
	</div>
	<div class="dhx_cal_header">
	</div>
	<div class="dhx_cal_data">
	</div>
</div>
</body>
