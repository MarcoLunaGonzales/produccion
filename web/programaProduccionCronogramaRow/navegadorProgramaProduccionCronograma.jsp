<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>






<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        
      
        <script >
            function nuevoAjax()
            {
                var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try
                    {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } 
                    catch (E)
                    {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }
                return xmlhttp;
            }
        
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
         function showModal()
         {
             var form=document.getElementById("form1");
             var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('panelMasAction').style.visibility='visible';
             document.getElementById("div_ProgramaProd").innerHTML='';
             document.getElementById("codTipoProgramaProd").value='-1';
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
           function ajaxGuardarCargarProgProdCron(nametable)
            {
                   var codigos='';
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;

                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var fecha=document.getElementById("fechaCronograma");
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           codigos=cellsElement[1].getElementsByTagName('input')[0].value;
                           codigos+=' '+cellsElement[2].innerHTML;
                         }

                     }

                   }
                   
                ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
                ajax.open("GET","ajaxGuardarCargarProgProdCron.jsf?codigos="+codigos+"&fecha="+fecha.value+"&time"+valor+"="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divAddCargos.innerHTML=ajax.responseText;
                        cargarCronogramaDeDia();
                   }
                }
                ajax.send(null);

          }
          function seleccion(celda)
          {
              
              var valor=celda.getElementsByTagName('input')[0].value;
              var elements=document.getElementById('ProgProdCronograma');
                    var j=0;
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++)
                    {
                        var cellsElement=rowsElement[i].cells;
                        
                        if(cellsElement[0].getElementsByTagName('input')[0]!=null)
                        {
                            j=0;
                        }
                        else
                          {
                              j=1;
                          }
                                if(cellsElement[j].innerHTML!='')
                                    {
                                        
                                        if(cellsElement[j].getElementsByTagName('input')[0].value==valor)
                                        {
                                            cellsElement[j].className='select';
                                            
                                            cellsElement[j+1].className='select';
                                        }
                                        else
                                        {
                                            cellsElement[j].className='';
                                            
                                            cellsElement[j+1].className='';
                                        }
                                    }
                                else
                                    {
                                    cellsElement[j].className='';
                                    
                                    cellsElement[j+1].className='';
                                    }
                          
                                    
                            
                     }
          }
          function cargarCronogramaDeDia()
          {
              
              ajax=nuevoAjax();
              var rango=(document.getElementById("checkRango").checked?'1':'0');
              var fechaInicial=document.getElementById("fechaInicioCronograma");
              var fechaFinal=document.getElementById("fechaCronograma");
              var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
              var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
              ajax.open("GET","ajaxCargarCronogramaDeDia.jsf?fechaInicio="+fechaInicial.value+"&fechaFinal="+fechaFinal.value+"&conRango="+rango+"&dat="+valor,true);
              ajax.onreadystatechange=function(){
              if (ajax.readyState==4) {
                     divAddCargos.innerHTML=ajax.responseText;
                 }
              }
                ajax.send(null);
          }
          function ajaxEliminarSeleccionados(button)
          {
             if(confirm('Esta Seguro de eliminar el lote del programa de produccion')==true)
             {
                  var col=button.parentNode.cellIndex;
                  var fila=button.parentNode.parentNode;
                  var codProgProdCron=fila.cells[(parseInt(col)-2)].getElementsByTagName('input')[0].value;

                  ajax=nuevoAjax();
                  var rango=(document.getElementById("checkRango").checked?'1':'0');
                  var fechaInicial=document.getElementById("fechaInicioCronograma");
                  var fechaFinal=document.getElementById("fechaCronograma");
                  var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
                  var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                  ajax.open("GET","ajaxEliminarProgProdCron.jsf?fechaInicio="+fechaInicial.value+"&fechaFinal="+fechaFinal.value+"&conRango="+rango+"&codProgProdCron="+codProgProdCron+"&dat="+valor,true);
                  ajax.onreadystatechange=function(){
                  if (ajax.readyState==4) {
                         divAddCargos.innerHTML=ajax.responseText;
                     }
                  }
                  ajax.send(null);
             }
          }
          
          function validarHora(input)
          {
                var hora=input.value.split(":");
                if(input.value!='')
                {
                     
                        if(hora.length!=2)
                        {
                            alert('Debe introducir una hora valida');
                            input.focus();
                            return false;
                        }
                        if(hora[0]<0||hora[0]>23||hora[0].length!=2)
                        {
                            alert('La horas introducida no son validas');
                            input.focus();
                            return false;
                        }
                        if(hora[1]<0||hora[1]>59||hora[0].length!=2)
                        {
                            alert('los minutos introducidos no son validos');
                            input.focus();
                            return false;
                        }
                }
                
          }



         function mostrarDetalle(celda)
         {
             var codProgProdCron=celda.parentNode.getElementsByTagName('input')[0].value;
             var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('divDetalle').style.visibility='visible';
             ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_detalleCronograma");
                ajax.open("GET","ajaxMostrarDetalle.jsf?codProgProdCron="+codProgProdCron+"&time"+valor+"="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divAddCargos.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
         }
         function changeCheckBox(check)
         {
             if(check.checked)
            {
                document.getElementById('spanFechaInicio').style.visibility='visible';
                document.getElementById('fechaInicioCronograma').style.visibility='visible';
                document.getElementById('imagenFecha').style.visibility='visible';
                document.getElementById('spanFechaFinal').innerHTML='Fecha Final';
            }
            else
            {
                document.getElementById('spanFechaInicio').style.visibility='hidden';
                document.getElementById('fechaInicioCronograma').style.visibility='hidden';
                document.getElementById('imagenFecha').style.visibility='hidden';
                document.getElementById('spanFechaFinal').innerHTML='Fecha Cronograma';
            }

             cargarCronogramaDeDia();
         }
         function mostrarDetalleMaquina(celda)
         {
           
            var fechaInicio='';
            var fechaFinal=document.getElementById('fechaCronograma').value;
            if(document.getElementById('checkRango').checked)
             {
                fechaInicio=document.getElementById('fechaInicioCronograma').value;
             }
             else
             {
                fechaInicio=fechaFinal;
             }
            document.getElementById('fechaInicio1').value=fechaInicio;
            document.getElementById('fechafinal1').value=fechaFinal;
              var codProgProdCron=celda.parentNode.getElementsByTagName('span')[0].innerHTML;
            var modal=document.getElementById("formsuper");
            document.getElementById('codMaquina').value=codProgProdCron;
             modal.style.visibility='visible';
             document.getElementById('divDetalleMaquina').style.visibility='visible';
             ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_detalleCronogramaMaquina");
                ajax.open("GET","ajaxMostrarDetalleMaquina.jsf?codMaquina="+codProgProdCron+"&time"+valor+"="+valor+"&fechaInicio="+fechaInicio+"&fechaFinal="+fechaFinal,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divAddCargos.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
              
              
              
         }
         function mostrarDetalleMaquinaDias()
         {

            var fechaInicio=document.getElementById('fechaInicio1').value;
            var fechaFinal=document.getElementById('fechaFinal1').value;
            var codMaquina=document.getElementById('codMaquina').value;
            var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('divDetalleMaquina').style.visibility='visible';
             ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_detalleCronogramaMaquina");
                ajax.open("GET","ajaxMostrarDetalleMaquina.jsf?codMaquina="+codMaquina+"&time"+valor+"="+valor+"&fechaInicio="+fechaInicio+"&fechaFinal="+fechaFinal,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divAddCargos.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null);
                
         }
        </script>
       <script src="scripts.js"></script>
       <style>
           .select
           {
                background-color:#9FEE9F;
           }
           .celda
           {
               width:40px;
           }
           .headerCol{
                height: 100%;
                color: #ffffff;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                background-color: #800080;
            }
       </style>

    </head>
        <body  onload="carga();">
        <h3 align="center">Cronograma de Maquinarias de Producción</h3>
        <%SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdf1= new SimpleDateFormat("dd/MM/yyyy");

        String fechaCronograma=sdf1.format(new Date());

        try{
            String[] arrayfecha=fechaCronograma.split("/");
            String fechaInicio="01/"+arrayfecha[1]+"/"+arrayfecha[2];
                    %>
        <center><div>
               <input type="checkbox" id="checkRango" value="false" onclick="changeCheckBox(this)"/>
               <br>
             <span id="spanFechaInicio" style="visibility:hidden">Fecha Inicio:</span>
             <input style="visibility:hidden" type="text"  size="12"  value="<%=fechaInicio%>" name="fechaInicioCronograma" class="inputText" onchange="cargarCronogramaDeDia()">
             <img id="imagenFecha" src="../img/fecha.bmp" style="visibility:hidden">
             <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaInicioCronograma" click_element_id="imagenFecha">
             </DLCALENDAR>
            <span id="spanFechaFinal">Fecha Cronograma:</span>
            
            <input type="text"  size="12"  value="<%=fechaCronograma%>" name="fechaCronograma" class="inputText" onchange="cargarCronogramaDeDia()">
                <img id="imagenFecha2" src="../img/fecha.bmp">
                <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaCronograma" click_element_id="imagenFecha2">
                 </DLCALENDAR>
       </div></center>
        <form method="post" action="reporteResumenDevoluciones.jsp" target="_blank" name="form1" >
          <center> <div  id="div_ProgramaProduccionCronograma">
                <%
                    SimpleDateFormat sdf2= new SimpleDateFormat("dd/MM/yyyy");
                    String fechaFormato=arrayfecha[2]+"/"+arrayfecha[1]+"/"+arrayfecha[0];
                    String  consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA,COUNT(ppcd.COD_MAQUINA) as cantRow"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on "+
                                     " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA inner join MAQUINARIAS m"+
                                     " on m.COD_MAQUINA=ppcd.COD_MAQUINA  "+
                                     " where ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA=1 and ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00' and '"+fechaFormato+" 23:59:59'"+
                                     " group by m.COD_MAQUINA,m.NOMBRE_MAQUINA order by min(ppcd.FECHA_INICIO), m.COD_MAQUINA,m.NOMBRE_MAQUINA";
                    System.out.println("consulta maq "+consulta);
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resDetalle;
                    out.println("<table id='ProgProdCronograma' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' class='border'>");
                    out.println("<tr class='headerClassACliente outputText2' ><th>Maquina</th><th>Producto</th><th>Tiempo</th></tr>");
                    while(res.next())
                    {
                        out.println("<tr class='outputText2' ><th ondblclick='mostrarDetalleMaquina(this)' align='left' class='headerCol outputText2' rowspan='"+res.getInt("cantRow")+"'><span style='visibility=hidden'>"+res.getString("COD_MAQUINA")+"</span>"+res.getString("NOMBRE_MAQUINA")+"</th>");
                        consulta="select ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA,cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,"+
                                 " ppp.NOMBRE_PROGRAMA_PROD,ppcd.FECHA_FINAL,ppcd.FECHA_INICIO,afm.ORDEN_ACTIVIDAD from PROGRAMA_PRODUCCION_CRONOGRAMA ppc"+
                                 " inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                                 " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                 " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppc.COD_COMPPROD inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD ="+
                                 " ppc.COD_PROGRAMA_PROD inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA ="+
                                 " ppc.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO = 1 inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA ="+
                                 " fm.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA = 96 and afm.COD_ESTADO_REGISTRO = 1"+
                                 " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1 "+
                                 " and maf.COD_MAQUINA = ppcd.COD_MAQUINA where ppcd.COD_MAQUINA = '"+res.getString("COD_MAQUINA")+"' and "+
                                 " ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00' and '"+fechaFormato+" 23:59:59' order by ppcd.FECHA_INICIO";
                        resDetalle=stDetalle.executeQuery(consulta);
                        System.out.println("consulta "+consulta);
                        if(resDetalle.next())
                        {
                            out.println("<th onmousedown='seleccion(this)' ondblclick='mostrarDetalle(this)' class='outputText2'> <input type='hidden' value='"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA")+"'/><span class='outputText2'>"+resDetalle.getString("nombre_prod_semiterminado")+"<br>"+resDetalle.getString("COD_LOTE_PRODUCCION")+"</span></th>");
                            out.println("<th class='outputText2'><span>"+sdf2.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"'/>-<span>"+sdf2.format(resDetalle.getTimestamp("FECHA_FINAL"))+"</span><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"'/></th><th><img onclick='ajaxEliminarSeleccionados(this)'src='../img/menos.png' alt='eliminar lote del programa'></th></tr>");

                        }
                        while(resDetalle.next())
                        {
                             out.println("<tr class='outputText2' ><th onmousedown='seleccion(this)' ondblclick='mostrarDetalle(this)' class='outputText2'><input type='hidden' value='"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA")+"'/>"+resDetalle.getString("nombre_prod_semiterminado")+"<br>"+resDetalle.getString("COD_LOTE_PRODUCCION")+"</th>");
                            out.println("<th class='outputText2'><span>"+sdf2.format(resDetalle.getTimestamp("FECHA_INICIO"))+"</span><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"'/>-<span>"+sdf2.format(resDetalle.getTimestamp("FECHA_FINAL"))+"</span><input type='text' class='celda' value='"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"'/></th><th><img onclick='ajaxEliminarSeleccionados(this)'src='../img/menos.png' alt='eliminar lote del programa'></th></tr>");

                        }
                        resDetalle.close();
                    }
                    out.println("</table>");
                    stDetalle.close();
                    res.close();
                    st.close();
                    con.close();
                    }
                catch(SQLException ex)
                {ex.printStackTrace();
                }

                %>
            </div></center>
            <br>
            <br>
                
            <center>
                <button class="btn" onclick=" showModal();">Agregar</button>
                <button class="btn" onclick="ajaxEliminarSeleccionados();" >Eliminar</button>
                
            </center>
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
          <center>
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
                            Periodo Programa Produccion:&nbsp;&nbsp;&nbsp;
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
                        <div id="div_ProgramaProd" style="overflow:auto;width:680px;height:390px;" >
                            <table id="programaProd">
                            </table>
                        </div>
                    <button class="btn" onclick="if(validarSeleccion('programaProd')==false){return false;}else{ajaxGuardarCargarProgProdCron('programaProd');document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
          </div>














          <div  id="divDetalle" style="
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
              <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'divDetalle')"  >Detalle</div>
                        <br>
                            Detalle de Maquinarias por Producto:&nbsp;&nbsp;&nbsp;

                        <div id="div_detalleCronograma" style="overflow:auto;width:680px;height:390px;" >
                            <table id="detalleCronograma">
                            </table>
                        </div>
                    <button class="btn" onclick="if(validarSeleccion('programaProd')==false){return false;}else{ajaxGuardarCargarProgProdCron('programaProd');document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('divDetalle').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
          </div>



          <div  id="divDetalleMaquina" style="
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
              <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'divDetalleMaquina')"  >Detalle</div>
              
                        <br>
                            Detalle de Productos por Maquinaria:&nbsp;&nbsp;&nbsp;
                            <center>
                                <span >Fecha Inicio:</span>
                                 <input  type="text"  size="12"  value="" name="fechaInicio1" class="inputText" onchange="mostrarDetalleMaquinaDias()">
                                 <img id="imagenFechaInicio" src="../img/fecha.bmp" >
                                 <DLCALENDAR tool_tip="Seleccione la Fecha Inicio " id="dlCalendar1"
                                                daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                                navbar_style="background-color: 7992B7; color:ffffff;"
                                                input_element_id="fechaInicio1" click_element_id="imagenFechaInicio">
                                 </DLCALENDAR>
                                <span id="spanFechaFinal">Fecha Final:</span>

                                <input type="text"  size="12"  value="" name="fechaFinal1" class="inputText" onchange="mostrarDetalleMaquinaDias()">
                                    <img id="imagenFechaFinal" src="../img/fecha.bmp">
                                    <DLCALENDAR tool_tip="Seleccione la Fecha Final"
                                                daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                                navbar_style="background-color: 7992B7; color:ffffff;"
                                                input_element_id="fechaFinal1" click_element_id="imagenFechaFinal" >

                                     </DLCALENDAR>
                            </center>
                        <div id="div_detalleCronogramaMaquina" style="overflow:auto;width:680px;height:390px;" >
                            <table id="detalleCronogramaMaquina">
                            </table>
                        </div>
                    <button class="btn" onclick="if(validarSeleccion('programaProd')==false){return false;}else{ajaxGuardarCargarProgProdCron('programaProd');document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('divDetalleMaquina').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
                    
          </div>





          </center>
          
        <input type="hidden" id="codMaquina" value=""/>

        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
</html>