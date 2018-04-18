package evaluaProveedores;


<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import="java.text.SimpleDateFormat"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>   
              function replicar(cod){
                    //alert(cod);
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                    arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                    url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                    //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf';			
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=350,height=250,left='+izquierda+ ',top=' + arriba + '' 
                    window.open(url, 'popUp',opciones)
              }
            
              function CerrarPlanilla(f){
                   /*var count=0;
                   var estadoPlanilla=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;*/
                   var codigo=0;
                   var count=0;
                   var elements=document.getElementById('form1');
                   //alert(elements.length);
                   var rowsElement=elements.length;
                   for(var j=0;j<rowsElement-1;j++){
                    //alert(elements[j].value);
                        if(elements[j].checked==true){
                             codigo=elements[j].value;
                             count++;
                        }
                   }
                   
                   if(count==1){                        
                      if( confirm("Esta seguro de Cerrar esta Planilla de Aguinaldos?")){
                            if( confirm("Los datos no podran ser modificados")){ 
                                //alert(codigo);
                                location.href="cerrarPlanillaAguinaldos.jsp?codigo="+codigo;
                                 return true
                            }else{ return false
                            }
                      }
                      else{return false
                      }
                   } else {
                       if(count==0){
                            alert("No escogio ningun registro");
                            return false;
                       }else 
                       if(count>1){
                            alert("Solo puede escoger un registro");
                            return false;
                       }
                   
                   }
                                        
                }    
            
           function registrar(f){
                 f.submit();
            }
            function eliminar(f)
            {
                var i;
                var j=0;
                var msj;
                var msj2;
                datos=new Array();
                for(i=0;i<=f.length-1;i++)
                {
                    if(f.elements[i].type=='checkbox')
                    {	if(f.elements[i].checked==true)
			{	datos[j]=f.elements[i].value;
				j=j+1;
			}
                    }
                }
                if(j==0)
                {	alert('Debe seleccionar al menos un registro para eliminar.');
                        return(false);
                }
                else
                {
                    msj=confirm("Al eliminar la Planilla, eliminara tambien el detalle, desea continuar?");
                    if (msj==true)
                    {	msj1=confirm("La Planilla sera eliminada, desea continuar?");
                        if (msj1==true)
                        {			
                            location.href="eliminarTipoIncentivoRegional.jsp?datos="+datos;
                        }
                    }
                }
             }
                                   </script>
    </head>
    <body>
        
        <form name="form1" action="guardarPeriodosEvaluacionProveedor.jsp">
            <%! Connection con=null;
            %>
            <%
            con=Util.openConnection(con);

            String sql="";
            String sql1="";
            String sql2="";
            String sql3="";
            String sql4="";
            String sql5="";
            String cod_gestion="";
            String nombre_gestion="";
            String cod_mes="";
            String nombre_mes="";
%>
          
            <h3 align="center">Registrar Periodos Evaluación de Proveedores</h3>
            <br>
             <table width="50%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">
                    <td  colspan="3" align="center" class=colh style="border : solid #f2f2f2 0px;">Introduzca los Datos</td>
                </tr>
                <tr style="border : solid #cccccc 1px;">
                    <td style="border : solid #f3f3f3 1px;">Gestión</td>
                    <td >::</td>
                    <td style="border : solid #f3f3f3 1px;">
                       <%
                        try{
                            sql="select cod_gestion, nombre_gestion from gestiones ";
                            sql+="where gestion_estado=1 ";
                            Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs = st.executeQuery(sql);
                            while (rs.next()) {

                                cod_gestion=rs.getString("cod_gestion");
                                nombre_gestion=rs.getString("nombre_gestion");
                            }
                        } catch(Exception e) {
                        }
                      %>
                    <%=nombre_gestion%></td>
                </tr>
                 <tr style="border : solid #cccccc 1px;">
                    <td style="border : solid #f3f3f3 1px;">Mes</td>
                    <td >::</td>
                    <td style="border : solid #f3f3f3 1px;">
                       <%
                        try{
                            sql2="select cod_mes, nombre_mes from meses ";
                            sql2+=" where cod_mes <13 ";
                            Statement st2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs2 = st2.executeQuery(sql2);
                        %>
                        <select name="cod_mes" class="inputText2">
                            <%
                            while (rs2.next()) {
                                cod_mes=rs2.getString("cod_mes");
                                nombre_mes=rs2.getString("nombre_mes");
                            %>
                                <option value="<%=cod_mes%>"><%=nombre_mes%></option>
                            <%
                            }
                            %>
                        </select>
                        <%
                        } catch(Exception e) {
                        }
                        %>
                    </td>
                </tr>
                 <tr>
                        <td>
                            Fecha Inicio Periodo Evaluación
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="" name="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio"; click_element_id="imagenFecha1">
                                        </DLCALENDAR>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Fecha Final Periodo Evaluación
                        </td>
                        <td >::</td>
                        <td>
                            <input type="text"  size="12"  value="" name="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final"; click_element_id="imagenFecha2">
                                        </DLCALENDAR>
                        </td>
                    </tr>
            </table>
            <input type="hidden" name="cod_gestion" value="<%=cod_gestion%>">
            <br>
            <div align="center">                
                <input type="button"   class="btn"  size="35" value="Adicionar" name="limpiar" onclick="registrar(this.form);">
                <input type="button"   class="btn"  size="35" value="Eliminar" name="limpiar"  onclick="eliminar(this.form);">
                
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>
