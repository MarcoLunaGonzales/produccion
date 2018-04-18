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
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%!
public Date addDiaFecha(Date fch) {
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fch.getTime());
        cal.add(Calendar.DATE,1);
        return new Date(cal.getTimeInMillis());
}
public String convertirFechaTexto(Date fecha)
{
    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat)nf;
                    form.applyPattern("00");
    String resultado=String.valueOf(fecha.getYear())+"/"+form.format(fecha.getMonth())+"/"+form.format(fecha.getDate());
    return resultado;
}

public String convertirFechaTextoNormal(Date fecha)
{
    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat)nf;
                    form.applyPattern("00");
    String resultado=String.valueOf(fecha.getDate())+"/"+form.format(fecha.getMonth())+"/"+form.format(fecha.getYear());
    return resultado;
}
%>



<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        
      
       
           
       <script src="scripts.js"></script>
       <style>
           .punteado{
              border-style: dotted;
           }
           .select{
           
            
            border-radius: 15px; /* Opera 10.5+ futuros navegadores y también IE6+ con IE-CSS3 */
             
            
           
            background-color:#9FEE9F;
             }
           .celda
           {
               width:120px;

           }
           .headerCol{
                height: 100%;
                color: #ffffff;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                background-color: #800080;
            }
       </style>
       <script src="scripts.js"></script>
       <script>
           var codProgprodDias=0;
           var celdaAgregar=null;
           var celdaEditar=null;
          function showModal(celda)
          {
             celdaAgregar=celda;
             document.getElementById("nombreProdReg").innerHTML=celda.getElementsByTagName('span')[0].innerHTML;
             var form=document.getElementById("form1");
         var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('panelMasAction').style.visibility='visible';
          }
          function editar(celda)
          {
             celdaEditar=celda;
             
             document.getElementById('nombreProdEditar').innerHTML=celda.getElementsByTagName('span')[0].innerHTML;
             document.getElementById('fechaInicioEditar').value=celda.getElementsByTagName('input')[0].value.split(" ")[0];
             document.getElementById('horaInicioEditar').value=celda.getElementsByTagName('input')[0].value.split(" ")[1];
                document.getElementById('fechaFinalEditar').value=celda.getElementsByTagName('input')[1].value.split(" ")[0];
                document.getElementById('horaFinalEditar').value=celda.getElementsByTagName('input')[1].value.split(" ")[1];
             var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('panelEditar').style.visibility='visible';
          }
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
            function ajaxGuardar()
            {
                
                var codComprod=celdaAgregar.getElementsByTagName('input')[0].value;
                var codLote=celdaAgregar.getElementsByTagName('input')[1].value;
                var codProgProd=celdaAgregar.getElementsByTagName('input')[2].value;
                var codTipoProg=celdaAgregar.getElementsByTagName('input')[3].value;
                var codFormula=celdaAgregar.getElementsByTagName('input')[4].value;
                var fechaInicio=document.getElementById('fechaInicioRegisto').value;
                var horaInicio=document.getElementById('horaInicialRegistro').value;
                var fechaFinal=document.getElementById('fechaFinalRegistro').value;
                var horaFinal=document.getElementById('horaFinalRegistro').value;
                ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
                ajax.open("GET","ajaxGuardarCronogramaProd.jsf?codCompProd="+codComprod+"&codLote="+codLote+"&codTipoProgProd="+
                        codTipoProg+"&codProgProd="+codProgProd+"&codFormula="+codFormula+"&fechaInicio="+fechaInicio+"&horaInicio="+
                        horaInicio+"&fechaFinal="+fechaFinal+"&horaFinal="+horaFinal+"&valor="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        var code=ajax.responseText;
                        ajaxFiltrarProdAreaEmpresa();
                   }
                }
                ajax.send(null);
                

          }
          function ajaxEditar()
            {

                var codComprod=celdaEditar.getElementsByTagName('input')[2].value;
                var codLote=celdaEditar.getElementsByTagName('input')[3].value;
                var codProgProd=celdaEditar.getElementsByTagName('input')[4].value;
                var codTipoProg=celdaEditar.getElementsByTagName('input')[5].value;
                var codFormula=celdaEditar.getElementsByTagName('input')[6].value;
                var fechaInicio=document.getElementById('fechaInicioEditar').value;
                var horaInicio=document.getElementById('horaInicioEditar').value;
                var fechaFinal=document.getElementById('fechaFinalEditar').value;
                var horaFinal=document.getElementById('horaFinalEditar').value;
                ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divAddCargos=document.getElementById("div_ProgramaProduccionCronograma");
                ajax.open("GET","ajaxEditarCronogramaProd.jsf?codCompProd="+codComprod+"&codLote="+codLote+"&codTipoProgProd="+
                        codTipoProg+"&codProgProd="+codProgProd+"&codFormula="+codFormula+"&fechaInicio="+fechaInicio+"&horaInicio="+
                        horaInicio+"&fechaFinal="+fechaFinal+"&horaFinal="+horaFinal+"&valor="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        var code=ajax.responseText;
                        ajaxFiltrarProdAreaEmpresa();
                   }
                }
                ajax.send(null);


          }
          function ajaxFiltarFecha()
            {
                var codProgProd=document.getElementById('codProgProd').value;
                var fechaInicio=document.getElementById('fechaInicioFiltro').value;
                var fechaFinal=document.getElementById('fechaFinalFiltro').value;
                var areaEmpresa=document.getElementById('codAreaEmpresa').value;
                ajax=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divCronograma=document.getElementById("div_cronograma");
                
                ajax.open("GET","ajaxCargarFiltroFecha.jsf?codProgProd="+codProgProd+"&codArea="+areaEmpresa+
                    "&fechaInicio="+fechaInicio+"&fechaFinal="+fechaFinal+"&valor="+valor,true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        divCronograma.innerHTML=ajax.responseText;
                   }
                }
                ajax.send(null);


          }
           function ajaxFiltrarProdAreaEmpresa()
            {
                var codProgProd=document.getElementById('codProgProd').value;
                var areaEmpresa=document.getElementById('codAreaEmpresa').value;
                ajax2=nuevoAjax();
                var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
                var divProductos=document.getElementById("div_prod");

                ajax2.open("GET","ajaxCargarProdAreaEmpresa.jsf?codProgProd="+codProgProd+"&codArea="+areaEmpresa+
                    "&valor="+valor,true);
                ajax2.onreadystatechange=function(){
                    if (ajax2.readyState==4) {
                        divProductos.innerHTML=ajax2.responseText;
                        ajaxFiltarFecha();
                   }
                }
                ajax2.send(null);
                

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
    </head>
    
    <body  onload="carga();">
        
       <%
       SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
       String nombreProgProd=request.getParameter("nomProgProd");
       String fechaFinal=sdf.format(new Date());
       String[] fechaArray=fechaFinal.split("/");
       String fechaInicio="01/"+fechaArray[1]+"/"+fechaArray[2];
       nombreProgProd=nombreProgProd.replace("'", " ");
       %>
       <h3 align="center">Cronograma de Produccion  </h3>
       <h3 align="center"><%=nombreProgProd%> </h3>
        <center><div>
               
             <span id="spanFechaInicio" >Fecha Inicio:</span>
             <input  type="text"  size="12"  value="<%=fechaInicio%>" name="fechaInicioFiltro" class="inputText" onchange="ajaxFiltarFecha()">
             <img id="imagenFecha" src="../img/fecha.bmp" >
             <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaInicioFiltro" click_element_id="imagenFecha">
             </DLCALENDAR>
            <span id="spanFechaFinal">Fecha Final:</span>
            
            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fechaFinalFiltro"  class="inputText" onchange="ajaxFiltarFecha()">
                <img id="imagenFecha2" src="../img/fecha.bmp">
                <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaFinalFiltro" click_element_id="imagenFecha2">
                 </DLCALENDAR>
                 <br>
                 <br>
                 <span>Area Empresa:</span>
                 <%
                 try
                 {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select  ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA from AREAS_EMPRESA ae where ae.COD_AREA_EMPRESA in (select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp )";
                    out.println("<select id='codAreaEmpresa' class='inputText' onchange='ajaxFiltrarProdAreaEmpresa()'>");
                    out.println("<option value='0' >-TODOS-</option>");
                    ResultSet res=st.executeQuery(consulta);
                    while(res.next())
                    {
                        out.println("<option value='"+res.getString("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                    }
                    out.println("</select>");
                    res.close();
                    st.close();
                    con.close();
                 }
                 catch(SQLException ex)
                 {
                     ex.printStackTrace();
                 }
                 %>
       </div></center>
        <form method="post" action="reporteResumenDevoluciones.jsp" target="_blank" name="form1" >
          <center> <div  id="div_ProgramaProduccionCronograma" >
<%

        try{
            String codProgramaprod=request.getParameter("codProgramaProd");
            out.println("<input type='hidden' value='"+codProgramaprod+"' id='codProgProd' >");
                String consulta=" select cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                " ,pp.COD_COMPPROD,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD" +
                                " from PROGRAMA_PRODUCCION pp"+
                                " inner join COMPONENTES_PROD cp on pp.COD_COMPPROD = cp.COD_COMPPROD"+
                                " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD ="+
                                " pp.COD_TIPO_PROGRAMA_PROD "+
                                " where pp.COD_PROGRAMA_PROD = '"+codProgramaprod+"' " +
                                " and CAST(pp.COD_COMPPROD as varchar)+' '+cast(pp.COD_FORMULA_MAESTRA as varchar)+"+
                                "' '+CAST(pp.COD_LOTE_PRODUCCION as varchar)+' '+cast(pp.COD_PROGRAMA_PROD as varchar)+"+
                                "' '+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar) not IN(select "+
                                "cast(ppcd.COD_COMPPROD as varchar)+' '+cast(ppcd.COD_FORMULA_MAESTRA as varchar)+"+
                                "' '+cast(ppcd.COD_LOTE_PRODUCCION as varchar)+' '+cast(ppcd.COD_PROGRAMA_PROD as varchar)+"+
                                "' '+cast(ppcd.COD_TIPO_PROGRAMA_PROD as varchar)"+
                                " from PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS ppcd )"+
                                "order by cp.nombre_prod_semiterminado";
                System.out.println("consulta cargarProductos "+consulta);
                Connection con=null;
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                
                out.println("<div class='headerClassACliente' style='margin-left:1%; position:absolute;width:19%; height:5%;'>Productos</div>");
                out.println("<div id='div_prod' style='margin-left:1%;margin-top:2%; position:absolute;overflow:auto;width:19%; height:72%;'>");
                
                out.println("<table id='ProgProdCronograma' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' style='width:100%;' class='border'>");
                out.println("<tbody id='tablaProgProdCronograma'>");
                
                
                
                    
                   ResultSet res=st.executeQuery(consulta);
                    while(res.next())
                    {
                        out.println("<tr class='outputText2' ><td style='cursor: move' onclick='showModal(this)' class='outputText2'><span>" +
                                res.getString("nombre_prod_semiterminado")+
                                "</span><br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+
                                "("+res.getString("COD_LOTE_PRODUCCION")+")" +
                                "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+

                                "</td>");
                               
                    }
                    out.println("</tbody>");
                    out.println("</table>");
                    out.println("</div>");

                    
                   
                    
               //inicio ale mostrar tablaHorarios
                fechaArray=fechaInicio.split("/");
                String fecha="select cast('"+fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" 00:00:00' as datetime) as fecha";

                Date fechaAct=new Date();
                Date fInicioDate=new Date();
                 res=st.executeQuery(fecha);
                if(res.next())
                {

                    fInicioDate=res.getTimestamp("fecha");

                }
                
                fechaArray=fechaFinal.split("/");
                fecha="select cast('"+fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" 23:59:59' as datetime) as fecha";
                res=st.executeQuery(fecha);
                Date fFinalDate= new Date();
                if(res.next())
                {
                    fFinalDate=res.getTimestamp("fecha");
                }

                SimpleDateFormat sdf1= new SimpleDateFormat("yyyy/MM/dd");
                SimpleDateFormat sdf2= new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdf3= new SimpleDateFormat("dd/MM/yyyy HH:mm");
                consulta="select cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppcd.COD_LOTE_PRODUCCION"+
                         " ,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL,ppcd.COD_COMPPROD,ppcd.COD_FORMULA_MAESTRA,ppcd.COD_LOTE_PRODUCCION,ppcd.COD_PROGRAMA_PROD,"+
                         " ppcd.COD_TIPO_PROGRAMA_PROD "+
                         " from PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS ppcd "+
                         " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppcd.COD_COMPPROD"+
                         " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcd.COD_TIPO_PROGRAMA_PROD"+
                         " where ppcd.COD_PROGRAMA_PROD='"+codProgramaprod+"' and  ((ppcd.FECHA_INICIO BETWEEN '"+sdf1.format(fInicioDate)+" 00:00:00' and '"+sdf1.format(fFinalDate)+" 23:59:59') "+
                         " or(ppcd.FECHA_FINAL BETWEEN '"+sdf1.format(fInicioDate)+" 00:00:00' and '"+sdf1.format(fFinalDate)+" 23:59:59'))" +
                         " order by cp.nombre_prod_semiterminado";
                System.out.println("consulta cargar horas "+consulta);
                res=st.executeQuery(consulta);
                out.println("<div id='div_cronograma' style='margin-left:21%; position:absolute;overflow:auto;width:75%;height:77%;'>");
                out.println("<table id='progProdCronogramaDias' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' class='border' > " );
                out.println("<tr class='headerClassACliente' >");
                fechaAct=(Date)fInicioDate.clone();
                fFinalDate=addDiaFecha(fFinalDate);
                while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
                {
                    out.println("<td>"+sdf.format(fechaAct)+"</td>");
                     fechaAct=addDiaFecha(fechaAct);
                }
                out.println("</tr>");
                Date fIniCon=new Date();
                Date fFinCon= new Date();
                while(res.next())
                {
                    fIniCon=res.getTimestamp("FECHA_INICIO");
                    fFinCon=res.getTimestamp("FECHA_FINAL");
                    fechaAct=(Date)fInicioDate.clone();
                     out.println("<tr class='outputText2'>");
                     int cont=0;
                    while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
                    {
                        if((sdf1.format(fechaAct).equals(sdf1.format(fIniCon)))||(fIniCon.before(fechaAct)&&fechaAct.before(fFinCon)))
                        {

                            cont++;
                        }
                        else
                        {
                           if(cont!=0)
                           {

                               out.println("<td colspan='"+cont+"' class='select' ondblclick='editar(this)'>" +
                                       "<input type='hidden' value='"+sdf3.format(fIniCon)+"'>"+
                                       "<input type='hidden' value='"+sdf3.format(fFinCon)+"'>"+
                                       "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+
                                       "<center><span>"+res.getString("nombre_prod_semiterminado")+"</span></br>"+
                                       res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+" ("+res.getString("COD_LOTE_PRODUCCION")+")  ("+sdf3.format(fIniCon)+" - "+sdf3.format(fFinCon)+")</center></td>");

                               cont=0;
                           }
                           else
                           {
                               out.println("<td ></td>");
                           }
                        }
                         fechaAct=addDiaFecha(fechaAct);
                    }
                    if(cont!=0)
                          {
                               out.println("<td colspan='"+cont+"' class='select' ondblclick='editar(this)'>" +
                                       "<input type='hidden' value='"+sdf3.format(fIniCon)+"'>"+
                                       "<input type='hidden' value='"+sdf3.format(fFinCon)+"'>"+
                                       "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+
                                       "<center><span>"+res.getString("nombre_prod_semiterminado")+"</span></br>"+
                                       res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+" ("+res.getString("COD_LOTE_PRODUCCION")+")  ("+sdf3.format(fIniCon)+" - "+sdf3.format(fFinCon)+")</center></td>");
                              
                               cont=0;
                           }
                      out.println("</tr>");
                }
                out.println("</table>");
                out.println("</div>");
                
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
                top:100px;
                position:absolute;
                left:300px;
                border :2px solid #FFFFFF;
                width :380px;
                height: 160px;
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
               <center>
      <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'panelMasAction')"  >Intervalo de Tiempo<br><span id="nombreProdReg"></span></div>
      <br>
      <table>
          <tr>
                 <td><span class="outputText2" >Fecha Inicio:</span></td>
                 <td><input  type="text"  size="12"  value="<%=fechaInicio%>" name="fechaInicioRegisto" class="inputText" >
                     <img id="imagenFecha1" src="../img/fecha.bmp" >
                     <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaInicioRegisto" click_element_id="imagenFecha1">
                     </DLCALENDAR>
                     </td>
                     <td><input type="text"  size="5"  value="00:00" name="horaInicialRegistro" onblur="validarHora(this)" class="inputText"></td>
              </tr>
              <tr>
                    <td><span class="outputText2">Fecha Final:</span></td>

                    <td><input type="text"  size="12"  value="<%=fechaFinal%>" name="fechaFinalRegistro" class="inputText">

                        <img id="imagenFechaFinal2" src="../img/fecha.bmp">
                        <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaFinalRegistro" click_element_id="imagenFechaFinal2">
                         </DLCALENDAR>
                         </td>
                         <td><input type="text"  size="5"  value="23:59" name="horaFinalRegistro" onblur="validarHora(this)" class="inputText"></td>
                             </tr>
                             </table>
                     <br>
                    <button class="btn" onclick="ajaxGuardar();document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
                    </center>
          </div >
          </center>
          
          
           <div  id="panelEditar" style="
               background-color: #FFFFFF;
                z-index: 2;
                top:100px;
                position:absolute;
                left:300px;
                border :2px solid #FFFFFF;
                width :380px;
                height: 160px;
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
               <center>
      <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'panelEditar')"  >Intervalo de Tiempo<br><span id="nombreProdEditar"></span></div>
      <br>
      <table>
          <tr>
                 <td><span class='outputText2' >Fecha Inicio:</span></td>
                 <td>   <input  type="text"  size="12"  value="" name="fechaInicioEditar" class="inputText" ></td>
                     <td><img id="imagenFecha11" src="../img/fecha.bmp" >
                     <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaInicioEditar" click_element_id="imagenFecha11">
                     </DLCALENDAR>
                    </td>
                   <td>  <input type="text"  size="5"  value="00:00" name="horaInicioEditar" onblur="validarHora(this)" class="inputText"></td>
              </tr>
                    <td><span class='outputText2'>Fecha Final:</span></td>

                    <td><input type="text"  size="12"  value="" name="fechaFinalEditar" class="inputText"></td>
                        <td><img id="imagenFechaFinal2" src="../img/fecha.bmp">
                        <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaFinalRegistro" click_element_id="imagenFechaFinal2">
                         </DLCALENDAR>
                         </td>
                        <td><input type="text"  size="5"  value="23:59" name="horaFinalEditar" onblur="validarHora(this)" class="inputText"></td>
                             </table>
                     <br>
                    <button class="btn" onclick="ajaxEditar();document.getElementById('panelEditar').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelEditar').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
                    </center>
          </div>
        

        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
</html>