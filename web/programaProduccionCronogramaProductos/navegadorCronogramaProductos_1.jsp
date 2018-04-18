package programaProduccionCronogramaProductos;

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
       <script src="scripts.js"></script>
       <script>
           var codProgprodDias=0;
           var celdaAgregar=null;
          function showModal(celda)
          {
              celdaAgregar=celda;
             var form=document.getElementById("form1");
             var modal=document.getElementById("formsuper");
             modal.style.visibility='visible';
             document.getElementById('panelMasAction').style.visibility='visible';
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
                alert(celdaAgregar.innerHTML);
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
                   }
                }
                ajax.send(null);
                

          }
       </script>
    </head>
    
    <body  onload="carga();">
        <h3 align="center">Cronograma de Dias Por Programa Produccion</h3>
       <%
       SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");

       String fechaFinal=sdf.format(new Date());
       String[] fechaArray=fechaFinal.split("/");
       String fechaInicio="01/"+fechaArray[1]+"/"+fechaArray[2];
       %>
        <center><div>
               
             <span id="spanFechaInicio" >Fecha Inicio:</span>
             <input  type="text"  size="12"  value="<%=fechaInicio%>" name="fechaInicioCronograma" class="inputText" onchange="cargarCronogramaDeDia()">
             <img id="imagenFecha" src="../img/fecha.bmp" >
             <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                            daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                            navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaInicioCronograma" click_element_id="imagenFecha">
             </DLCALENDAR>
            <span id="spanFechaFinal">Fecha Final:</span>
            
            <input type="text"  size="12"  value="<%=fechaFinal%>" name="fechaCronograma" class="inputText">
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

        try{
            String codProgramaprod=request.getParameter("codProgramaProd");
                String consulta=" select cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                " ,pp.COD_COMPPROD,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD" +
                                " ,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL" +
                                " from PROGRAMA_PRODUCCION pp"+
                                " inner join COMPONENTES_PROD cp on pp.COD_COMPPROD = cp.COD_COMPPROD"+
                                " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD ="+
                                " pp.COD_TIPO_PROGRAMA_PROD left outer join PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS ppcd"+
                                " on ppcd.COD_COMPPROD=pp.COD_COMPPROD and ppcd.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                " and ppcd.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and ppcd.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                " and ppcd.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD "+
                                " where pp.COD_PROGRAMA_PROD = '"+codProgramaprod+"' order by cp.nombre_prod_semiterminado";
                System.out.println("consulta cargarProductos "+consulta);
                Connection con=null;
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                fechaArray=fechaInicio.split("/");
                String fecha="select cast('"+fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" 00:00:00' as datetime) as fecha";
                
                Date fechaAct=new Date();
                Date fInicioDate=new Date();
                ResultSet res=st.executeQuery(fecha);
                if(res.next())
                {
                    
                    fInicioDate=res.getTimestamp("fecha");
                    
                }
                fechaAct=(Date)fInicioDate.clone();
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
                
                out.println("<table id='ProgProdCronograma' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' class='border'>");
                out.println("<tbody id='tablaProgProdCronograma'>");
                out.println("<tr class='headerClassACliente'><td style='width:250px'>Productos</td>");
                System.out.println("fecha "+sdf1.format(fechaAct)+" "+sdf1.format(fFinalDate));
                
                    while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
                                {
                                    out.println("<td>"+sdf2.format(fechaAct)+"</td>");
                                    fechaAct=addDiaFecha(fechaAct);
                                }
                     res=st.executeQuery(consulta);
                    while(res.next())
                    {
                        out.println("<tr class='outputText2' ><td style='width:250px;cursor: move' onclick='showModal(this)'>" +
                                "<a href>"+res.getString("nombre_prod_semiterminado")+
                                "<br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+
                                "("+res.getString("COD_LOTE_PRODUCCION")+")</a>" +
                                "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+

                                "</td>");
                                fechaAct=(Date)fInicioDate.clone();
                                boolean conRegistro=(res.getString("FECHA_INICIO")!=null);
                                Date fIniCon=res.getTimestamp("FECHA_INICIO");
                                while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
                                {
                                    if(conRegistro)
                                    {
                                        if(fechaAct.after(fIniCon))
                                        {
                                            
                                            out.println("<td class='select'><span>hila</span></td>");
                                        }
                                        else
                                        {
                                            out.println("<td class='punteado'><span>hi</span></td>");
                                        }
                                    }
                                    else
                                        {
                                    out.println("<td class='punteado'><span>hi</span></td>");
                                    }
                                fechaAct=addDiaFecha(fechaAct);
                                }
                                
                    }
                    out.println("</tbody>");
                    out.println("</table>");

                    
                   
                    
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
                top: 12px;
                position:absolute;
                left:300px;
                border :2px solid #FFFFFF;
                width :380px;
                height: 120px;
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
      <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'panelMasAction')"  >Intervalo de Tiempo</div>
                 <span >Fecha Inicio:</span>
                     <input  type="text"  size="12"  value="<%=fechaInicio%>" name="fechaInicioRegisto" class="inputText" onchange="cargarCronogramaDeDia()">
                     <img id="imagenFecha1" src="../img/fecha.bmp" >
                     <DLCALENDAR tool_tip="Seleccione la Fecha Inicio del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaInicioRegisto" click_element_id="imagenFecha1">
                     </DLCALENDAR>
                     
                     <input type="text"  size="5"  value="00:00" name="horaInicialRegistro" class="inputText">
                         <br>
                    <span >Fecha Final:</span>

                    <input type="text"  size="12"  value="<%=fechaFinal%>" name="fechaFinalRegistro" class="inputText">
                        <img id="imagenFechaFinal2" src="../img/fecha.bmp">
                        <DLCALENDAR tool_tip="Seleccione la Fecha del Cronograma"
                                    daybar_style="background-color: DBE1E7; font-family: verdana; color:000000;"
                                    navbar_style="background-color: 7992B7; color:ffffff;"
                                    input_element_id="fechaFinalRegistro" click_element_id="imagenFechaFinal2">
                         </DLCALENDAR>
                         <input type="text"  size="5"  value="23:59" name="horaFinalRegistro" class="inputText">
                     <br>
                    <button class="btn" onclick="ajaxGuardar()">Guardar</button>
                    <button class="btn" onclick="{document.getElementById('panelMasAction').style.visibility='hidden';document.getElementById('formsuper').style.visibility='hidden';}">Cancelar</button>
          </div>














          




          </center>
          
        

        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
</html>