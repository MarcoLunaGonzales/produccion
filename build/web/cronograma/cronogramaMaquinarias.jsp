<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="com.google.gson.Gson" %>
<%@page import="java.io.*" %>
<%@page import="com.cofar.json.*" %>
<%@page import="com.cofar.*" %>
<%@page import="com.cofar.bean.*" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%!
String cargarCronogramaMaquinas(){
    String cronogramaMaquinas = "";
try{
    Gson gson = new Gson();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    Connection con = null;
    con = Util.openConnection(con);
    Date fecha = new Date();
    String consulta = " select m.COD_MAQUINA,cp.COD_COMPPROD,m.NOMBRE_MAQUINA,cp.nombre_prod_semiterminado, pprc.COD_LOTE_PRODUCCION ,pprcd.FECHA_INICIO,pprcd.FECHA_FINAL" +
             " from" +
             " PROGRAMA_PRODUCCION_CRONOGRAMA pprc inner join " +
             " PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE pprcd on pprc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = pprcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA" +
             " inner join maquinarias m on m.COD_MAQUINA = pprcd.COD_MAQUINA" +
             " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pprc.COD_COMPPROD" +
             " where pprcd.FECHA_INICIO between '"+sdf1.format(fecha)+" 00:00:00' and '"+sdf1.format(fecha)+" 23:59:59'" +
             " or pprcd.FECHA_FINAL between '"+sdf1.format(fecha)+" 00:00:00' and '"+sdf1.format(fecha)+" 23:59:59'"+
             " order by pprcd.fecha_final asc";
    System.out.println("consulta " + consulta);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(consulta);
    List lista = new ArrayList();
    while(rs.next()){
        CronogramaMaquinaria c = new CronogramaMaquinaria();
        //c.setId(rs.getString("cod_maquina"));
        c.setSection_id(rs.getString("cod_maquina"));
        c.setText(rs.getString("cod_lote_produccion")+" "+rs.getString("nombre_prod_semiterminado"));
        c.setStart_date(sdf.format(rs.getTimestamp("FECHA_INICIO")));
        c.setEnd_date(sdf.format(rs.getTimestamp("FECHA_FINAL")));
        lista.add(c);
    }
    cronogramaMaquinas= gson.toJson(lista);
    //CronogramaMaquinaria c = new CronogramaMaquinaria();

}catch(Exception e){e.printStackTrace();}
    return cronogramaMaquinas;
}
String cargarMaquinas(){
    String maquinas = "";
    try{
    Gson gson = new Gson();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
    Connection con = null;
    con = Util.openConnection(con);
    String consulta = " select distinct m.COD_MAQUINA,m.NOMBRE_MAQUINA" +
             " from" +
             " PROGRAMA_PRODUCCION_CRONOGRAMA pprc inner join " +
             " PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE pprcd on pprc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = pprcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA" +
             " inner join maquinarias m on m.COD_MAQUINA = pprcd.COD_MAQUINA" +
             " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pprc.COD_COMPPROD ";
    System.out.println("consulta " + consulta);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(consulta);
    List lista = new ArrayList();
    while(rs.next()){
        SeccionesMaquina s = new SeccionesMaquina();
        s.setKey(rs.getString("cod_maquina"));
        s.setLabel(rs.getString("nombre_maquina"));
        lista.add(s);
    }
    maquinas = gson.toJson(lista);
    //CronogramaMaquinaria c = new CronogramaMaquinaria();

}catch(Exception e){e.printStackTrace();}
    return maquinas;
}
%>
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<title>Cronograma Produccion</title>
    
	<script src='codebase/dhtmlxscheduler.js' type="text/javascript" charset="utf-8"></script>
	<script src='codebase/ext/dhtmlxscheduler_timeline.js' type="text/javascript" charset="utf-8"></script>
	<script src="codebase/ext/dhtmlxscheduler_serialize.js" type="text/javascript" charset="utf-8"></script>
	<script src='codebase/ext/dhtmlxscheduler_tooltip.js' type="text/javascript" charset="utf-8"></script>
    <script src="sources/locale/locale_es.js" charset="utf-8"></script>
    <script src="sources/locale/recurring/locale_recurring_es.js" ></script>
    <script src="codebase/ext/dhtmlxscheduler_pdf.js" type="text/javascript" charset="utf-8"></script>
    <script src="codebase/ext/dhtmlxscheduler_limit.js" type="text/javascript" charset="utf-8"></script>

	<link rel='stylesheet' type='text/css' href='codebase/dhtmlxscheduler.css'>
	<link rel='stylesheet' type='text/css' href='../css/ventas.css'>
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

        function validarSeleccion(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;

                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];

                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;

                         }

                     }

                   }
                   if(count==1){

                      return true;
                      //alert('true');
                   }
                   if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   if(count>1){
                       alert('Solo puede seleccionar un registro');
                       return false;
                   }

         }
        function ajaxFiltrarProgramaProd(celda)
            {
                var date = new Date();
                var timestamp = date.getTime();
                ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_ProgramaProd");
                ajax.open("GET","ajaxFiltroProgramaProd.jsf?codProgramaProd="+celda.value+"&time"+valor+"="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divAddCargos.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);

          }
        function showModal()
         {
             var form=document.getElementById("form1");
             var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('panelMasAction').style.visibility='visible';
             document.getElementById("div_ProgramaProd").innerHTML='';
             document.getElementById("codTipoProgramaProd").value='-1';
         }
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
         function obtieneFecha(){
            return scheduler._date.getDate() + "/" +(scheduler._date.getMonth()+1) + "/" + scheduler._date.getFullYear();
        }
        
        function ajaxGuardarCargarProgProdCron(nametable)
            {
                //sel_todoDistrito();
                   var codigos='';
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;

                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    //alert(scheduler._date.getDate() + " " +(scheduler._date.getMonth()+1) + " " + scheduler._date.getFullYear());
                    //break;
                    //var fecha=document.getElementById("fechaCronograma");
                    
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           codigos+=(codigos==''?'':',')+cellsElement[1].getElementsByTagName('input')[0].value;
                           codigos+=' '+cellsElement[2].innerHTML;
                           //Session["codigos"]=codigos;
                          // sessionStorage.setItem('codigos',codigos);
                         }
                     }
                   }
                   //alert(codigos);
                   //return null;

                var fecha= this.obtieneFecha();
                ajax=nuevoAjax();
                var valor=Math.random();

                //var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
                var vardss="ajaxGuardarCargarProgProdCron.jsf?time="+valor+"&codigos="+codigos+"&fecha="+fecha;
                ajax.open("POST","ajaxGuardarCargarProgProdCron.jsf",true); //"+codigos+"
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        //var contenido = this.cargarCronogramaMaquinas();
                       // scheduler.clearAll();
                        //var a = eval(this.cargarSeccionesMaquinas());
                        //scheduler.updateCollection("timeline", a);
                        scheduler.load("ajaxCargarCronograma.jsp?fecha="+fecha+"&cod="+Math.random(), "json");
                        //alert("paso 2");
                          location = "cronogramaMaquinarias.jsp";
                        //divAddCargos.innerHTML=ajax.responseText;
                        //cargarCronogramaDeDia();
                   }
                }
                ajax.setRequestHeader("Content-type","application/x-www-form-urlencoded");
                ajax.send("time="+valor+"&codigos="+codigos +"&fecha="+fecha);
          }
        function cargarSeccionesMaquinas()
            {
                var seccionesMaquina = "";
                ajax=nuevoAjax();

                ajax.open("GET","ajaxCargarMaquina.jsp?fecha="+this.obtieneFecha()+"&cod="+Math.random(),true);
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
                ajax.open("GET","ajaxCargarCronograma.jsp?fecha="+this.obtieneFecha()+"&cod="+Math.random(),true);
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
            //alert(sections);
            sections = eval(<%=cargarMaquinas()%>);
            //alert(sections);
            
            //alert(cronogramaMaquina);

			scheduler.createTimelineView({
				name:	"timeline",
				x_unit:	"minute",
				x_date:	"%H:%i",
				x_step:	30,
				x_size: 24,
				x_start: 16,
				x_length: 48,
				y_unit:	sections,
				y_property:	"section_id",
				render:"bar",
                event_dy:40
			});
            //24

			//===============
			// Data loading
			//===============
			scheduler.config.lightbox.sections=[
				{name:"description", height:130, map_to:"text", type:"textarea" , focus:true},
				{name:"custom", height:23, type:"select", options:sections, map_to:"section_id" },
				{name:"time", height:72, type:"time", map_to:"auto"}
			];

			scheduler.init('scheduler_here',new Date(),"timeline"); //timeline
            
			/*scheduler.parse([
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
			],"json");*/
            //scheduler.blockTime(new Date(2014,2,1), "fullday");
			//scheduler.blockTime(new Date(2014,2,5), [0,10*60]);
            
            scheduler.parse(eval(<%=cargarCronogramaMaquinas()%>),"json");
            var a = document.getElementById("prev_button");
            //alert(a);
            a.attachEvent("onclick", function(){
            scheduler.clearAll();
            scheduler.load("ajaxCargarCronograma.jsp?fecha="+this.obtieneFecha()+"&cod="+Math.random(), "json");});
            document.getElementById("next_button").attachEvent("onclick", function(){scheduler.clearAll();
            scheduler.load("ajaxCargarCronograma.jsp?fecha="+this.obtieneFecha()+"&cod="+Math.random(), "json");});
        
		}
        function siguiente_action(){
            document.getElementsByName("");
        }
        function addIEonScroll() {
            var thisContainer = document.getElementById('prev_button');
            if (!thisContainer) { return; }
            var onClickAction = 'actualiza()';
            thisContainer.onclick = new Function(onClickAction);
            }
        function actualiza(){
            alert("actualiza");

        }
		function show() {
		alert(scheduler.toJSON());
        console.log(scheduler.toJSON());
		}
        function seleccionarTodo(){
                    //alert('entro');
                    var seleccionar_todo=document.getElementById('seleccionar_todo');
                    var elements=document.getElementById('programaProd');

                    if(seleccionar_todo.checked==true){
                        //alert('entro por verdad');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=true;
                            }
                        }
                    }
                    else
                    {//alert('entro por false');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=false;
                            }
                        }

                    }
                    return true;
                }
	</script>
</head>
<body onload="init();carga()">
<%--input type="button" name="show" value="Show" onclick="show()" style="right:400px;" /--%>
<div id="scheduler_here" class="dhx_cal_container" style='width:100%; height:80%;overflow:auto'>
	<div class="dhx_cal_navline">
        <div class='dhx_cal_export pdf' id='export_pdf' title='Export to PDF' onclick='scheduler.toPDF("http://localhost:13431/scheduler-pdf/generate", "color")'>&nbsp;</div>
		<div class="dhx_cal_prev_button" id="prev_button">&nbsp;</div>
		<div class="dhx_cal_next_button" id="next_button">&nbsp;</div>
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
<div align="center">
<button class="btn" onclick=" showModal();">Agregar</button>
</div>
<div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
</div>
<%--  panel agregar programa produccion  --%>
<div  id="panelMasAction" style="
               background-color: #FFFFFF;
                z-index: 2;
                top: 12px;
                position:absolute;
                left:300px;
                border :2px solid #FFFFFF;
                width :700px;
                height: 480px;
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
              <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'panelMasAction')"  >Escoger Programa Producción</div>
                        <br>
                            Periodo Programa Produccion:&nbsp;&nbsp;&nbsp;<br/>
                      <select id="codTipoProgramaProd" name="codTipoProgramaProd" onchange="ajaxFiltrarProgramaProd(this)">
                           <option selected value="-1">-SELECCIONE UNA OPCION-</option>
                           <%

                                   try{
                                       String consulta="select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_ESTADO_PROGRAMA<>4";
                                       Connection con=null;
                                       con=Util.openConnection(con);
                                       Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                       ResultSet res=st.executeQuery(consulta);

                                       while(res.next())
                                       {
                                           out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                       }

                                       res.close();
                                       st.close();
                                       con.close();
                                   }
                                   catch(SQLException ex)
                                   {
                                       ex.printStackTrace();
                                   }
                           %>
                           </select>
                           <br/>
                           Seleccionar Todos:<input type="checkbox"  onclick="seleccionarTodo()" id="seleccionar_todo" />
                        <div id="div_ProgramaProd" style="overflow:auto;width:680px;height:390px;" >
                            <table id="programaProd">
                            </table>
                        </div>
                    <button class="btn" onclick="ajaxGuardarCargarProgProdCron('programaProd');document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
</div>
</body>
