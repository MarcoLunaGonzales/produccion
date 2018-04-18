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
                   }
                }
                ajax.send(null);

          }
          function seleccion(celda)
          {
              
              var valor=celda.getElementsByTagName('input')[0].value;
              var elements=document.getElementById('ProgProdCronograma');
              
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        
                            for(j=0;j<cellsElement.length;j++)
                            {
                                if(cellsElement[j].innerHTML!='')
                                    {
                                        if(cellsElement[j].getElementsByTagName('input')[0].value==valor)
                                        {
                                            cellsElement[j].className='select';
                                            j++;
                                            cellsElement[j].className='select';
                                        }
                                        else
                                        {
                                            cellsElement[j].className='';
                                            j++;
                                            cellsElement[j].className='';
                                        }
                                    }
                                else
                                    {
                                    cellsElement[j].className='';
                                    j++;
                                    cellsElement[j].className='';
                                    }
                                    
                            }
                        }
          }
          function cargarCronogramaDeDia(celda)
          {
              var date = new Date();
              var timestamp = date.getTime();
              ajax=nuevoAjax();
              var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
              ajax.open("GET","ajaxCargarCronogramaDeDia.jsf?fecha="+celda.value+"&dat="+timestamp,true);
              ajax.onreadystatechange=function(){
              if (ajax.readyState==4) {
                     divAddCargos.innerHTML=ajax.responseText;
                 }
              }
                ajax.send(null);
          }
          function ajaxEliminarSeleccionados()
          {
                
                    var elements=document.getElementById('ProgProdCronograma');
                    var codProgProdCron='';
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;

                            for(j=0;j<cellsElement.length;j++)
                            {
                                if(cellsElement[j].innerHTML!='')
                                    {
                                        if(cellsElement[j].className!='')
                                         {
                                             codProgProdCron=cellsElement[j].getElementsByTagName('input')[0].value;
                                         }
                                    }
                                    j++;
                            }
                    }
                    alert(codProgProdCron);
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
        </script>
       <script src="scripts.js"></script>
       <style>
           .select
           {
                background-color:#9FEE9F;
           }
       </style>

    </head>
    <body  onload="carga();">
        <h3 align="center">Cronograma de Maquinarias de Producción</h3>
        <%SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdf1= new SimpleDateFormat("dd/MM/yyyy");

        String fechaCronograma=sdf1.format(new Date());
        try{
                    %>
        <center><div>Fecha Cronograma:&nbsp;
        <input type="text" onblur="validarHora(this)"></input>
            <input type="text"  size="12"  value="<%=fechaCronograma%>" name="fechaCronograma" class="inputText" onchange="cargarCronogramaDeDia(this)">
                <img id="imagenFecha2" src="../img/fecha.bmp">
                <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaCronograma" click_element_id="imagenFecha2">
                 </DLCALENDAR>
       </div></center>
        <form method="post" action="reporteResumenDevoluciones.jsp" target="_blank" name="form1" >
            <div  id="div_ProgramaProduccionCronograma">
                <%
                String[] arrayfecha=fechaCronograma.split("/");
                String fechaFormato=arrayfecha[2]+"/"+arrayfecha[1]+"/"+arrayfecha[0];
                    String  consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA from MAQUINARIAS m  where m.COD_MAQUINA in (select DISTINCT ppcd.COD_MAQUINA"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                                     " ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA =1 and "+
                                     " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " where ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00' and '"+fechaFormato+" 23:59:59' )";
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resDetalle;
                        
                        out.println("<table id='ProgProdCronograma' class='border'>");
                        out.println("<tr class='headerClassACliente outputText2'>");
                        List<List<String>> valores= new ArrayList<List<String>>();
                        valores.clear();
                        int contAux=0;
                        int contRow=0;
                        while(res.next())
                        {
                            out.println("<td  ><div width='120px'>"+res.getString("NOMBRE_MAQUINA")+"<div></td><td>Hora</td>");
                            consulta=" select ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA,cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,ppcd.FECHA_FINAL,ppcd.FECHA_INICIO,afm.ORDEN_ACTIVIDAD"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd"+
                                     " on ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppc.COD_COMPPROD "+
                                     " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD" +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=ppc.COD_FORMULA_MAESTRA and "+
                                     " fm.COD_ESTADO_REGISTRO=1 inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA="+
                                     " fm.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA=96 and afm.COD_ESTADO_REGISTRO=1"+
                                     " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA"+
                                     " and maf.COD_ESTADO_REGISTRO=1 and maf.COD_MAQUINA=ppcd.COD_MAQUINA"+
                                     " where ppcd.COD_MAQUINA='"+res.getString("COD_MAQUINA")+"' " +
                                     "  and ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00'  and '"+fechaFormato+" 23:59:59' order by ppcd.FECHA_INICIO";
                            System.out.println("consulta cargar prod "+consulta);
                            resDetalle=stDetalle.executeQuery(consulta);
                            List<String> lista= new ArrayList<String>();
                            contAux=0;
                            while(resDetalle.next())
                            {
                                lista.add(resDetalle.getString("nombre_prod_semiterminado")+"("+resDetalle.getString("COD_LOTE_PRODUCCION")+")#"+resDetalle.getString("ORDEN_ACTIVIDAD")+"#"+sdf.format(resDetalle.getTimestamp("FECHA_INICIO"))+"#"+sdf.format(resDetalle.getTimestamp("FECHA_FINAL"))+"#"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA"));
                                contAux++;
                            }
                            
                            valores.add(lista);
                            if(contAux>contRow)
                            {
                                contRow=contAux;
                            }

                        }
                        System.out.println("fila "+contRow);
                        for(int fila=0;fila<contRow;fila++)
                        {
                            out.println("<tr class='outputText2'>");
                            for(int col=0;col<valores.size();col++)
                            {
                                if(fila<valores.get(col).size())
                                    {
                                        String[] mostrar=valores.get(col).get(fila).split("#");
                                        out.println("<td onmousedown='seleccion(this)'><input type='hidden' value='"+mostrar[4]+"'/><span>("+mostrar[1]+") </span>"+mostrar[0]+"</td><td><input type='text' value='"+mostrar[2]+"' style='width:36px'/><input type='text' value='"+mostrar[3]+"' style='width:36px'/></td>");
                                    }
                                else
                                {
                                    out.println("<td></td><td></td>");
                                } 
                            }
                            out.println("</tr>");
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
            </div>
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
              <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'panelMasAction')"  >Detalle</div>
                        <br>
                            Detalle de Maquinarias por Producto:&nbsp;&nbsp;&nbsp;
                      
                        <div id="div_detalleCronograma" style="overflow:auto;width:680px;height:390px;" >
                            <table id="detalleCronograma">
                            </table>
                        </div>
                    <button class="btn" onclick="if(validarSeleccion('programaProd')==false){return false;}else{ajaxGuardarCargarProgProdCron('programaProd');document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
          </div>

          </center>
          
        
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
</html>